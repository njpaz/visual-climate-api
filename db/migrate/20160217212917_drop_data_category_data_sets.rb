class DropDataCategoryDataSets < ActiveRecord::Migration
  def up
    drop_table :data_category_data_sets
  end

  def down
    create_table :data_category_data_sets do |t|
      t.integer :data_category_id
      t.integer :data_set_id

      t.timestamps
    end
  end
end
