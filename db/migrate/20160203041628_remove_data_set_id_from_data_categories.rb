class RemoveDataSetIdFromDataCategories < ActiveRecord::Migration
  def change
    remove_column :data_categories, :data_set_id
  end
end
