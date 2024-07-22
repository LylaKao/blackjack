module Scoreable
  def cards
    @cards ||= Card.where(id: card_ids)
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
