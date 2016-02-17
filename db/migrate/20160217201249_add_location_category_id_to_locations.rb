class AddLocationCategoryIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :location_category_id, :integer
  end
end
