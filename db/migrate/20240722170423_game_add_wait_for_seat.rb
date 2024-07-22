class GameAddWaitForSeat < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :wait_for_seat_id, :integer, default: 0
  end
end
