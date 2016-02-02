class AddIdentifierIndexToLocation < ActiveRecord::Migration
  def change
    add_index :locations, :identifier, unique: true
  end
end
