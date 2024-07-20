class Game < ApplicationRecord
  attr_reader :settings, :players, :dealer, :cards

  def initialize(settings_id)
    @settings = GameSetting.find(settings_id)

    # {seat_id: player}
    @dealer = Dealer.new
    @players = {}
    # @players[Dealer::DEALER_SEAT_ID] = @dealer # TODO Check max seat and seat id
  end

  def start_game
    initial_cards

    deal_cards_to_all_players
    deal_card_to_dealer
    deal_cards_to_all_players
    deal_card_to_dealer
  end

  def add_player(seat_id, user_id, name)
    @players[seat_id] = Player.new(seat_id, user_id, name)
  end

  def remove_player(seat_id)
    @players.delete(seat_id)
  end

  def deal_cards_to_all_players
    @players.each do |_seat_id, player|
      player.take_card(@cards.pop)
    end
  end

  def deal_card_to_player(seat_id)
    @players[seat_id].take_card(@cards.pop)
  end

  def deal_card_to_dealer
    @dealer.take_card(@cards.pop)
  end

  private

  def initial_cards
    @cards = []
    @settings.deck_count.times do
      @cards += Deck.new.cards
    end
    @cards.shuffle!
  end
end
