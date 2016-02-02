class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string  :identifier
      t.string  :latitude
      t.string  :longitude
      t.string  :name
      t.string  :elevation_unit
      t.integer :data_coverage
      t.integer :data_set_id
      t.integer :location_id
      t.integer :data_category_id
      t.integer :data_type_id
      t.date    :min_date
      t.date    :max_date

      t.timestamps null: false
    end
  end
end
