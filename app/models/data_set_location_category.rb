class DataSetLocationCategory < ActiveRecord::Base
  include PopulateJoin

  belongs_to :data_set
  belongs_to :location_category

  @call_class = LocationCategory
  @compare_class = DataSet
end
