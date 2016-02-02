class AddIdentifierIndexToDataType < ActiveRecord::Migration
  def change
    add_index :data_types, :identifier, unique: true
  end
end
