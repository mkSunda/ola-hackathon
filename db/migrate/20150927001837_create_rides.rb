class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.integer :user_id
      t.integer :location_id
      t.integer :crn
      t.string :driver_name
      t.string :driver_number
      t.string :cab_type
      t.string :cab_number
      t.string :car_model
      t.datetime :arrival_time
      t.decimal :driver_lat, :precision => 10, :scale => 8
      t.decimal :driver_lng, :precision => 10, :scale => 8

      t.timestamps null: false
    end
  end
end
