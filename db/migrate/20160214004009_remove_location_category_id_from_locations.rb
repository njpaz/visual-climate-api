class RemoveLocationCategoryIdFromLocations < ActiveRecord::Migration
  def change
    remove_column :locations, :location_category_id, :integer
  end
end
