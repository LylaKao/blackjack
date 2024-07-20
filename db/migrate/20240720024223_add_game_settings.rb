class AddGameSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :game_settings do |t|
      t.integer :max_players
      t.integer :min_bet
      t.integer :deck_count
    end
  end
end
