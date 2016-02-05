class RemoveDataCategoryIdFromDataTypes < ActiveRecord::Migration
  def change
    remove_column :data_types, :data_category_id
  end
end
