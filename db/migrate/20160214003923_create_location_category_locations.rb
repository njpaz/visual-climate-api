class CreateLocationCategoryLocations < ActiveRecord::Migration
  def change
    create_table :location_category_locations do |t|
      t.integer :location_category_id
      t.integer :location_id

      t.timestamps null: false
    end
  end
end
