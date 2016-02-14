class DataSetLocation < ActiveRecord::Base
  include PopulateJoin

  belongs_to :data_set
  belongs_to :location

  @call_class = Location
  @compare_class = DataSet
end
