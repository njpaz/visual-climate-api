class RemoveStationIdFromDataTypes < ActiveRecord::Migration
  def change
    remove_column :data_types, :station_id, :integer
  end
end
