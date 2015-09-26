class CreateScheduledBookings < ActiveRecord::Migration
  def change
    create_table :scheduled_bookings do |t|
      t.integer :user_id
      t.integer :location_id
      t.datetime :pickup_time
      t.string :status

      t.timestamps null: false
    end
  end
end
