class CreateDataSets < ActiveRecord::Migration
  def change
    create_table :data_sets do |t|
      t.string  :identifier
      t.integer :data_coverage
      t.integer :data_type_id
      t.integer :location_id
      t.integer :station_id
      t.date    :min_date
      t.date    :max_date

      t.timestamps null: false
    end
  end
end
