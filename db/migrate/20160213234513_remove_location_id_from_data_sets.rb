class RemoveLocationIdFromDataSets < ActiveRecord::Migration
  def change
    remove_column :data_sets, :location_id, :integer
  end
end
