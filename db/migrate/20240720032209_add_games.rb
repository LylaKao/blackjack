class AddGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.integer :settings_id
      t.json :dealer_cards, default: []
      t.json :deck_cards, default: []
      t.json :players, default: {}
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
