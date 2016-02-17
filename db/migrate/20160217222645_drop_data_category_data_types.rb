class DropDataCategoryDataTypes < ActiveRecord::Migration
  def up
    drop_table :data_category_data_types
  end

  def down
    create_table :data_category_data_types do |t|
      t.integer :data_category_id
      t.integer :data_type_id

      t.timestamps null: false
    end
  end
end
