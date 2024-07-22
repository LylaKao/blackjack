class UserGameAddBetResult < ActiveRecord::Migration[7.1]
  def change
    add_column :user_games, :bet_result, :integer, default: 0
  end
end
