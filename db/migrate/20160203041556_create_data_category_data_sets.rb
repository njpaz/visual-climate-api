class CreateDataCategoryDataSets < ActiveRecord::Migration
  def change
    create_table :data_category_data_sets do |t|
      t.integer :data_category_id
      t.integer :data_set_id

      t.timestamps
    end
  end
end
