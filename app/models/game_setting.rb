# == Schema Information
#
# Table name: game_settings
#
#  id          :integer          not null, primary key
#  max_players :integer
#  min_bet     :integer
#  deck_count  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class GameSetting < ApplicationRecord
  validates :max_players, presence: true
  validates :min_bet, presence: true
  validates :deck_count, presence: true

  has_many :game
end
