class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.integer :pincode
      t.decimal :lat
      t.decimal :lat

      t.timestamps null: false
    end
  end
end
