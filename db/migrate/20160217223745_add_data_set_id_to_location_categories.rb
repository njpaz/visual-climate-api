class AddDataSetIdToLocationCategories < ActiveRecord::Migration
  def change
    add_column :location_categories, :data_set_id, :integer
  end
end
