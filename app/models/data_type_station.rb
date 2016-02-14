class DataTypeStation < ActiveRecord::Base
  include PopulateJoin

  belongs_to :data_type
  belongs_to :station

  @call_class = Station
  @compare_class = DataType
end
