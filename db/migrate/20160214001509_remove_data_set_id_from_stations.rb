class RemoveDataSetIdFromStations < ActiveRecord::Migration
  def change
    remove_column :stations, :data_set_id, :integer
  end
end
