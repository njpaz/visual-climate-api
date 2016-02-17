class AddLocationIdToDataTypes < ActiveRecord::Migration
  def change
    add_column :data_types, :location_id, :integer
  end
end
