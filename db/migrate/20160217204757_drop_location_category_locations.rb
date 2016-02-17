class DropLocationCategoryLocations < ActiveRecord::Migration
  def change
    drop_table :location_category_locations
  end
end
