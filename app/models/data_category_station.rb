class DataCategoryStation < ActiveRecord::Base
  include PopulateJoin

  belongs_to :data_category
  belongs_to :station

  @call_class = Station
  @compare_class = DataCategory
end
