class RemoveDataCategoryIdFromStations < ActiveRecord::Migration
  def change
    remove_column :stations, :data_category_id
  end
end
