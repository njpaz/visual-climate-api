class RemoveDataSetIdFromLocations < ActiveRecord::Migration
  def change
    remove_column :locations, :data_set_id, :integer
  end
end
