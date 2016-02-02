class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string  :identifier
      t.string  :name
      t.integer  :data_coverage
      t.integer :data_set_id
      t.integer :location_category_id
      t.integer :data_category_id
      t.date    :min_date
      t.date    :max_date

      t.timestamps null: false
    end
  end
end
