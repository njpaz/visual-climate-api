class AddDataCategoryIdToDataTypes < ActiveRecord::Migration
  def change
    add_column :data_types, :data_category_id, :integer
  end
end
