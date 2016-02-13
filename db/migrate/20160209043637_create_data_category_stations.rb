class CreateDataCategoryStations < ActiveRecord::Migration
  def change
    create_table :data_category_stations do |t|
      t.integer :data_category_id
      t.integer :station_id

      t.timestamps null: false
    end
  end
end
