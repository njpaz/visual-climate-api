class CreateLocationStations < ActiveRecord::Migration
  def change
    create_table :location_stations do |t|
      t.integer :location_id
      t.integer :station_id

      t.timestamps null: false
    end
  end
end
