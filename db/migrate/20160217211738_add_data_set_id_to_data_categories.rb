class AddDataSetIdToDataCategories < ActiveRecord::Migration
  def change
    add_column :data_categories, :data_set_id, :integer
  end
end
