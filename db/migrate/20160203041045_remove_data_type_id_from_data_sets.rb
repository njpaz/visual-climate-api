class RemoveDataTypeIdFromDataSets < ActiveRecord::Migration
  def change
    remove_column :data_sets, :data_type_id
  end
end
