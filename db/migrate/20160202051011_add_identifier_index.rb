class AddIdentifierIndex < ActiveRecord::Migration
  def change
    add_index :data_sets, :identifier, unique: true
    add_index :data_categories, :identifier, unique: true
    add_index :location_categories, :identifier, unique: true
    add_index :stations, :identifier, unique: true
  end
end
