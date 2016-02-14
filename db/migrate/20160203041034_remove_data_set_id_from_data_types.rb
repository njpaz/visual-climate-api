class RemoveDataSetIdFromDataTypes < ActiveRecord::Migration
  def change
    remove_column :data_types, :data_set_id, :integer
  end
end
