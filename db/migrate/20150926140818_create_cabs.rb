class CreateCabs < ActiveRecord::Migration
  def change
    create_table :cabs do |t|
      t.string :name
      t.integer :base_fare
      t.decimal :cost_per_distance
      t.decimal :waiting_cost_per_minute
      t.decimal :ride_cost_per_minute
      t.decimal :minimum_distance
      t.integer :minimum_time

      t.timestamps null: false
    end
  end
end
