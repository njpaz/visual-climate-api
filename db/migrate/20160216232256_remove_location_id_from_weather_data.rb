class RemoveLocationIdFromWeatherData < ActiveRecord::Migration
  def change
    remove_column :weather_data, :location_id, :integer
  end
end
