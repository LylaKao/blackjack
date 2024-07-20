class AddUserGames < ActiveRecord::Migration[7.1]
  def change
    create_table :user_games do |t|
      t.integer :user_id
      t.integer :game_id
      t.integer :seat_id
      t.integer :bet
      t.json :cards, default: []
    end
  end
end
