class AddGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.integer :settings_id
      t.json :dealer_card_ids, default: []
      t.json :deck_card_ids, default: []
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
