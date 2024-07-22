# == Schema Information
#
# Table name: user_games
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  game_id    :integer
#  seat_id    :integer
#  bet        :integer
#  card_ids   :json
#  status     :integer          default("pending")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UserGame < ApplicationRecord
  include Scoreable

  belongs_to :user
  belongs_to :game

  enum status: { pending: 0, active: 1, pass: 2, win: 3, lose: 4, draw: 5 }

  delegate :nickname, to: :user

  def active!
    update!(status: :active)
  end

  def take_card(card_id)
    card_ids << card_id
  end

  def decorate_cards
    cards.map(&:decorate)
  end
end
