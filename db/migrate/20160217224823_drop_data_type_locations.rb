class DropDataTypeLocations < ActiveRecord::Migration
  def up
    drop_table :data_type_locations
  end

  def down
    create_table :data_type_locations do |t|
      t.integer :data_type_id
      t.integer :location_id

      t.timestamps null: false
    end
  end
end
