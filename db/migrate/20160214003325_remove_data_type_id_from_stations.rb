class RemoveDataTypeIdFromStations < ActiveRecord::Migration
  def change
    remove_column :stations, :data_type_id, :integer
  end
end
