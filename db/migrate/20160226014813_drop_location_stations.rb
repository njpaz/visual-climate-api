class DropLocationStations < ActiveRecord::Migration
  def up
    drop_table :location_stations
  end

  def down
    create_table :location_stations do |t|
      t.integer :location_id
      t.integer :station_id

      t.timestamps null: false
    end
  end
end
