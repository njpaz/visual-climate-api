class RemoveDataSetIdFromLocationCategories < ActiveRecord::Migration
  def change
    remove_column :location_categories, :data_set_id
  end
end
