class AddDescriptionToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :description, :text
  end
end
