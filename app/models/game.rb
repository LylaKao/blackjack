class Game < ApplicationRecord
  attr_reader :settings, :dealer

  DEFAULT_SETTINGS_ID = 1

  enum status: { pending: 0, started: 1, finished: 2 }

  def self.create_or_get_current_game(settings_id = DEFAULT_SETTINGS_ID)
    game = Game.last

    if game.nil?
      game = Game.new
      game.init_settings(settings_id)
      game.save! if game.new_record?
    end

    game
  end

  def init_settings(settings_id)
    @settings = GameSetting.find(settings_id)

    # {seat_id: player}
    @dealer = Dealer.new
    players = {}
    self
  end


  def start_game
    check_players
    initial_cards

    show = false
    deal_cards_to_active_players(show)
    deal_card_to_dealer(show)

    show = true
    deal_cards_to_active_players(show)
    deal_card_to_dealer(show)
  end

  def active_players
    raise "Not enough players" if players.size < 0
    raise "Too many players" if players.size > @settings.max_players

    players.values.map(&:active!)
  end

  def add_player!(seat_id, bet, user_id)
    raise "Seat #{seat_id} is already taken" if players.key?(seat_id)

    players[seat_id] = Player.new(seat_id, bet, user_id)
  end

  def remove_player(seat_id)
    players.delete(seat_id)
  end

  def deal_cards_to_active_players(show = true)
    @active_players ||= players.select do |seat_id, player|
      player.active?
    end

    @active_players.each do |seat_id, _player|
      deal_card_to_player(seat_id, show)
    end
  end

  def deal_card_to_player(player, show = true)
    player.take_card(deck_cards.pop, show)
  end

  def deal_card_to_dealer(show = true)
    @dealer.take_card(deck_cards.pop, show)
  end

  private

  def initial_cards
    deck_cards = []
    @settings.deck_count.times do
      deck_cards += Deck.new.cards
    end
    deck_cards.shuffle!
  end
end
