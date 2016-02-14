class CreateDataSetLocations < ActiveRecord::Migration
  def change
    create_table :data_set_locations do |t|
      t.integer :data_set_id
      t.integer :location_id

      t.timestamps null: false
    end
  end
end
