class CreateDataSetStations < ActiveRecord::Migration
  def change
    create_table :data_set_stations do |t|
      t.integer :data_set_id
      t.integer :station_id

      t.timestamps null: false
    end
  end
end
