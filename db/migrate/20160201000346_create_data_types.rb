class CreateDataTypes < ActiveRecord::Migration
  def change
    create_table :data_types do |t|
      t.string  :identifier
      t.integer :data_coverage
      t.integer :data_set_id
      t.integer :location_id
      t.integer :station_id
      t.integer :data_category_id
      t.date    :min_date
      t.date    :max_date

      t.timestamps null: false
    end
  end
end
