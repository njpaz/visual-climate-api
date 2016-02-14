class RemoveLocationIdFromDataCategories < ActiveRecord::Migration
  def change
    remove_column :data_categories, :location_id, :integer
  end
end
