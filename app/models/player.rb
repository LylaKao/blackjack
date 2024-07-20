class Player
  attr_reader :seat_id, :bet, :cards, :status

  STATUS = { pending: 0, active: 1 }

  def initialize(seat_id, bet, user_id = 0)
    @seat_id = seat_id
    @bet = bet
    @user_id = user_id
    @cards = []
    @status = :pending
  end

  def name
    @name ||= User.find(@user_id).name
  end

  def active?
    @status == :active
  end

  def active!
    @status = :active
  end

  def take_card(card)
    @cards << card
  end

  def discard_card(card)
    @cards.delete(card)
  end

  def dealer?
    false
  end

  def score
    score = 0
    ace_count = 0

    cards.each do |card|
      if card.rank == "A"
        ace_count += 1
        score += 11
      else
        # J, Q, K count as 10
        score += card.rank.to_i == 0 ? 10 : card.rank.to_i
      end
    end

    while score > 21 && ace_count > 0
      score -= 10
      ace_count -= 1
    end

    score
  end
end
