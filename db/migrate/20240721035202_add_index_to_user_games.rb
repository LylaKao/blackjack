class AddIndexToUserGames < ActiveRecord::Migration[7.1]
  def change
    add_index :user_games, :user_id, name: :index_user_id
    add_index :user_games, :game_id, name: :index_game_id
  end
end
