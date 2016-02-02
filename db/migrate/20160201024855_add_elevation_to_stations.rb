class AddElevationToStations < ActiveRecord::Migration
  def change
    add_column :stations, :elevation, :decimal
  end
end
