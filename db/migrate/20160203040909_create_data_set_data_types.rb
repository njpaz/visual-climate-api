class CreateDataSetDataTypes < ActiveRecord::Migration
  def change
    create_table :data_set_data_types do |t|
      t.integer :data_set_id
      t.integer :data_type_id

      t.timestamps
    end
  end
end
