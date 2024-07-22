# == Schema Information
#
# Table name: games
#
#  id              :integer          not null, primary key
#  settings_id     :integer
#  dealer_card_ids :json
#  deck_card_ids   :json
#  status          :integer          default("pending")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Game < ApplicationRecord
  include Scoreable

  DEFAULT_SETTINGS_ID = 1
  DEALER_NAME = "Dealer"

  enum status: { pending: 0, started: 1, finished: 2 }

  has_many :user_games
  belongs_to :settings, class_name: "GameSetting", foreign_key: "settings_id"

  def self.create_or_get_current_game(settings_id = DEFAULT_SETTINGS_ID)
    game = Game.last

    game = create_new_game(settings_id) if game.nil?
    game
  end

  def self.create_new_game(settings_id = DEFAULT_SETTINGS_ID)
    ActiveRecord::Base.transaction do
      # prev_game = Game.last
      # prev_user_ids = prev_game&.user_games&.pluck(:user_id) || []

      game = Game.new
      game.settings = GameSetting.find(settings_id)
      game.save!

      # prev_user_ids.each do |user_id|
      #   user = User.find(user_id)
      #   user.user_games.create!(game_id: game.id)
      # end
      ActionCable.server.broadcast(GameChannel::CHANNEL_NAME, { type: "force_update" })
      game
    end
  end

  # for Scoreable
  def card_ids
    dealer_card_ids
  end

  def start_game
    ActiveRecord::Base.transaction do
      active_user_games!
      started!
      update(deck_card_ids: initial_cards)

      deal_cards_to_active_users
      deal_card_to_dealer

      deal_cards_to_active_users
      deal_card_to_dealer


      update!(wait_for_seat_id: find_next_seat_id)
      save!
      user_games.map(&:save!)
    end

    ActionCable.server.broadcast(GameChannel::CHANNEL_NAME, { type: "force_update" })
  end

  def find_next_seat_id
    return 0 if actived_users.empty?

    actived_users.map(&:seat_id).sort.first
  end

  def pass!
    ActiveRecord::Base.transaction do
      user_games.find_by(seat_id: wait_for_seat_id).pass!

      next_seat_id = find_next_seat_id
      update!(wait_for_seat_id: next_seat_id)
    end

    ActionCable.server.broadcast(GameChannel::CHANNEL_NAME, { type: "wait_for_seat", seat_id: wait_for_seat_id })
  end

  def call!
    user_game = user_games.find_by(seat_id: wait_for_seat_id)
    deal_card_to_user(user_game)

    ActiveRecord::Base.transaction do
      if user_game.score > 21
        user_game.lose!
        next_seat_id = find_next_seat_id

        # if next_seat_id == 0
        #   end_game
        # end

        update!(wait_for_seat_id: next_seat_id)
      end

      user_game.save!
      save!
    end

    ActionCable.server.broadcast(GameChannel::CHANNEL_NAME, { type: 'force_update' })
  end

  def add_user(user_id, seat_id, bet)

    raise "Seat #{seat_id} is already taken" if user_games.any? { |ug| ug.seat_id == seat_id }
    raise "You are already in the game" if user_games.any? { |ug| ug.user_id == user_id }
    raise "You can't join the game" if user_games.size >= settings.max_players
    raise "You can't bet less than minimum bet (#{settings.min_bet})" if bet < settings.min_bet

    user = User.find(user_id)
    raise "You don't have enough point" if user.point < bet

    user_game = user.user_games.build(game_id: id)
    user_game.seat_id = seat_id
    user_game.bet = bet
    user_game.save

    data = { type: 'user_joined', nickname: user.nickname, seat_id: seat_id, bet: bet }
    ActionCable.server.broadcast(GameChannel::CHANNEL_NAME, data)
  end

  def remove_user(user_id)
    user_game = user_games.find_by(user_id: user_id)
    seat_id = user_game.seat_id
    user_game.destroy

    ActionCable.server.broadcast(GameChannel::CHANNEL_NAME, { type: "user_left", seat_id: seat_id })
  end

  def deal_card_to_user(user_game)
    card_id = deck_card_ids.pop
    user_game.take_card(card_id)
  end

  def deal_card_to_dealer
    card_id = deck_card_ids.pop
    dealer_card_ids << card_id
  end

  def end_game
    ActiveRecord::Base.transaction do
      user_games.each do |ug|
        user = ug.user
        if ug.score > dealer_score && ug.score <= 21
          ceof = ug.score == 21 ? 2 : 1
          user.point += ug.bet * ceof
          ug.win!
        elsif ug.score <= 21 && dealer_score > 21
          user.point += ug.bet
          ug.win!
        elsif ug.score == dealer_score
          ug.draw!
        else
          user.point -= ug.bet
          ug.lose!
        end
        user.save!
      end
      finished!
    end

    ActionCable.server.broadcast(GameChannel::CHANNEL_NAME, { type: "force_update" })
  end

  def dealer_score
    score
  end

  private

  def initial_cards
    card_ids = []
    settings.deck_count.times do
      card_ids += Card.all.pluck(:id)
    end
    card_ids.shuffle!
  end

  def active_user_games!
    raise "Not enough players" if user_games.size < 0
    raise "Too many players" if user_games.size > settings.max_players

    user_games.map(&:active!)
  end

  def actived_users
    @actived_users ||= user_games.select(&:active?)
  end

  def deal_cards_to_active_users
    actived_users.each do |ug|
      deal_card_to_user(ug)
    end
  end
end
