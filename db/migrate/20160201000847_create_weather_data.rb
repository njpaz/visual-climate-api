class CreateWeatherData < ActiveRecord::Migration
  def change
    create_table :weather_data do |t|
      t.string  :attributes
      t.integer :data_set_id
      t.integer :data_type_id
      t.integer :location_id
      t.integer :station_id
      t.integer :value
      t.date    :date

      t.timestamps null: false
    end
  end
end
