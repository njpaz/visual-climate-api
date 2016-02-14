class CreateDataTypeStations < ActiveRecord::Migration
  def change
    create_table :data_type_stations do |t|
      t.integer :data_type_id
      t.integer :station_id

      t.timestamps null: false
    end
  end
end
