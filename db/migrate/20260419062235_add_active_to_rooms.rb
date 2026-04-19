class AddActiveToRooms < ActiveRecord::Migration[8.0]
  def change
    add_column :rooms, :active, :boolean
  end
end
