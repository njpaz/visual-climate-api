class CreateDataCategoryLocations < ActiveRecord::Migration
  def change
    create_table :data_category_locations do |t|
      t.integer :data_category_id
      t.integer :location_id

      t.timestamps null: false
    end
  end
end
