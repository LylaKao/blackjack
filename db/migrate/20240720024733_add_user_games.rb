class AddUserGames < ActiveRecord::Migration[7.1]
  def change
    create_table :user_games do |t|
      t.integer :user_id
      t.integer :game_id
      t.integer :point
      t.integer :bet
      t.json :cards
    end
  end
end
