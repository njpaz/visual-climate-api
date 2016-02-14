class RemoveLocationIdFromStations < ActiveRecord::Migration
  def change
    remove_column :stations, :location_id, :integer
  end
end
