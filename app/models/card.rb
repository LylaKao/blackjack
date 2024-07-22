# == Schema Information
#
# Table name: cards
#
#  id         :integer          not null, primary key
#  suit       :string
#  rank       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Card < ApplicationRecord
  validates :suit, presence: true
  validates :rank, presence: true

  Card::SUITS = %i(heart diamond club spade)
  Card::RANKS = %w(2 3 4 5 6 7 8 9 10 J Q K A)
end
