class DataSetStation < ActiveRecord::Base
  include PopulateJoin

  belongs_to :data_set
  belongs_to :station

  @call_class = Station
  @compare_class = DataSet
end
