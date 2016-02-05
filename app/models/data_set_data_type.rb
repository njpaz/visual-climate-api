class DataSetDataType < ActiveRecord::Base
  include PopulateJoin

  belongs_to :data_set
  belongs_to :data_type

  @call_class = DataType
  @compare_class = DataSet
end
