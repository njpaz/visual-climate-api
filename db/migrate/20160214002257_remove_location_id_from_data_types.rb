class RemoveLocationIdFromDataTypes < ActiveRecord::Migration
  def change
    remove_column :data_types, :location_id, :integer
  end
end
