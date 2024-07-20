class AddGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.integer :game_id
      t.json :players
      t.json :cards
    end
  end
end
