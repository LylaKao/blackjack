class GameSetting < ApplicationRecord
  validates :max_players, presence: true
  validates :min_bet, presence: true
  validates :deck_count, presence: true
end
