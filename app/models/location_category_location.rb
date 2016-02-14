class LocationCategoryLocation < ActiveRecord::Base
  include PopulateJoin

  belongs_to :location_category
  belongs_to :location

  @call_class = Location
  @compare_class = LocationCategory

end
