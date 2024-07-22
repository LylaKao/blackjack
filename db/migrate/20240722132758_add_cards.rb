class AddCards < ActiveRecord::Migration[7.1]
  def change
    create_table :cards do |t|
      t.string :suit
      t.string :rank
      t.timestamps
    end
  end
end
