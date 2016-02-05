class CreateDataCategoryDataTypes < ActiveRecord::Migration
  def change
    create_table :data_category_data_types do |t|
      t.integer :data_category_id
      t.integer :data_type_id

      t.timestamps null: false
    end
  end
end
