class Card
  attr_reader :suit, :rank

  Card::SUITS = %i(heart diamond club spade)
  Card::RANKS = %w(2 3 4 5 6 7 8 9 10 J Q K A)

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def suit_icon
    case suit
      when :heart then "♥"
      when :diamond then "♦"
      when :club then "♣"
      when :spade then "♠"
    end
  end

  def to_s
    "#{suit_icon} #{rank}"
  end
end
