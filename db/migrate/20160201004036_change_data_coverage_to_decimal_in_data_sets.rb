class ChangeDataCoverageToDecimalInDataSets < ActiveRecord::Migration
  def change
    change_column :data_sets, :data_coverage, :decimal
  end
end
