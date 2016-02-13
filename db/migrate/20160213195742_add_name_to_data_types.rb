class AddNameToDataTypes < ActiveRecord::Migration
  def change
    add_column :data_types, :name, :string
  end
end
