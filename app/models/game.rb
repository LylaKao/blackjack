# == Schema Information
#
# Table name: games
#
#  id           :integer          not null, primary key
#  settings_id  :integer
#  dealer_cards :json
#  deck_cards   :json
#  players      :json
#  status       :integer          default("pending")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Game < ApplicationRecord
  attr_reader :dealer

  DEFAULT_SETTINGS_ID = 1
  DEALER_NAME = "Dealer"

  enum status: { pending: 0, started: 1, finished: 2 }

  has_many :user_games
  belongs_to :settings, class_name: "GameSetting", foreign_key: "settings_id"

  def self.create_or_get_current_game(settings_id = DEFAULT_SETTINGS_ID)
    game = Game.last

    if game.nil?
      game = Game.new
      game.settings = GameSetting.find(settings_id)
      game.save! if game.new_record?
    end

    game
  end

  def start_game
    active_user_games
    initial_cards

    show = false
    deal_cards_to_active_players(show)
    deal_card_to_dealer(show)

    show = true
    deal_cards_to_active_players(show)
    deal_card_to_dealer(show)
  end

  def active_user_games
    raise "Not enough players" if active_user_games.size < 0
    raise "Too many players" if active_user_games.size > settings.max_players

    active_user_games.values.map(&:active!)
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

  def deal_cards_to_active_users(show = true)
    @actived_users ||= user_games.select do |ug|
      ug.active?
    end

    @actived_users.each do |ug|
      deal_card_to_user(ug, show)
    end
  end

  def deal_card_to_user(user_game, show = true)
    user_game.take_card(deck_cards.pop, show)
  end

  def deal_card_to_dealer(show = true)
    card = deck_cards.pop
    card.show = show
    dealer_cards << card
  end

  private

  def initial_cards
    deck_cards = []
    settings.deck_count.times do
      deck_cards += Deck.new.cards
    end
    deck_cards.shuffle!
  end
end
