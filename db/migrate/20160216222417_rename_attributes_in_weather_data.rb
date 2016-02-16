class RenameAttributesInWeatherData < ActiveRecord::Migration
  def change
    rename_column :weather_data, :attributes, :data_attributes
  end
end
