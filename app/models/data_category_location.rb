class DataCategoryLocation < ActiveRecord::Base
  include PopulateJoin

  belongs_to :data_category
  belongs_to :location

  @call_class = Location
  @compare_class = DataCategory
end
