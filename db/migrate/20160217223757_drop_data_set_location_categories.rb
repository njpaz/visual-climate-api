class DropDataSetLocationCategories < ActiveRecord::Migration
  def up
    drop_table :data_set_location_categories
  end

  def down
    create_table :data_set_location_categories do |t|
      t.integer :location_category_id
      t.integer :data_set_id

      t.timestamps null: false
    end
  end
end
