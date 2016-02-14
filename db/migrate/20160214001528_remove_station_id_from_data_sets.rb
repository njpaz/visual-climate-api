class RemoveStationIdFromDataSets < ActiveRecord::Migration
  def change
    remove_column :data_sets, :station_id, :integer
  end
end
