# == Schema Information
#
# Table name: user_games
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  game_id    :integer
#  seat_id    :integer
#  bet        :integer
#  cards      :json
#  status     :integer          default("pending")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UserGame < ApplicationRecord
  belongs_to :user
  belongs_to :game

  enum status: { pending: 0, active: 1 }

  delegate :nickname, to: :user

  def active?
    status == :active
  end

  def active!
    update!(status: :active)
  end

  def take_card(card)
    cards << card
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
