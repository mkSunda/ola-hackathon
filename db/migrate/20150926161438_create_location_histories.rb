class CreateLocationHistories < ActiveRecord::Migration
  def change
    create_table :location_histories do |t|
      t.integer :location_id
      t.integer :cab_id
      t.integer :eta
      t.float :distance
      t.string :type
      t.string :surcharge_type
      t.float :surcharge_value

      t.timestamps null: false
    end
  end
end
