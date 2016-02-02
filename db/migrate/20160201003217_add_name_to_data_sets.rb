class AddNameToDataSets < ActiveRecord::Migration
  def change
    add_column :data_sets, :name, :string
  end
end
