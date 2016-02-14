class RemoveDataCategoryIdFromLocations < ActiveRecord::Migration
  def change
    remove_column :locations, :data_category_id, :integer
  end
end
