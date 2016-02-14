class CreateDataTypeLocations < ActiveRecord::Migration
  def change
    create_table :data_type_locations do |t|
      t.integer :data_type_id
      t.integer :location_id

      t.timestamps null: false
    end
  end
end
