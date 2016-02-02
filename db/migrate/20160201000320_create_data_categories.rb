class CreateDataCategories < ActiveRecord::Migration
  def change
    create_table :data_categories do |t|
      t.string  :identifier
      t.string  :name
      t.integer :data_set_id
      t.integer :location_id

      t.timestamps null: false
    end
  end
end
