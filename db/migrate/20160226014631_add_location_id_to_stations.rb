class AddLocationIdToStations < ActiveRecord::Migration
  def change
    add_column :stations, :location_id, :integer
  end
end
