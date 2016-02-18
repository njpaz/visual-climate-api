class RecreateDataSetLocationCategories < ActiveRecord::Migration
  def change
    create_table :data_set_location_categories do |t|
      t.integer :location_category_id
      t.integer :data_set_id

      t.timestamps null: false
    end
  end
end
