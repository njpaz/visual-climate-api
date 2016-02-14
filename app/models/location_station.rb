class LocationStation < ActiveRecord::Base
  include PopulateJoin

  belongs_to :location
  belongs_to :station

  @call_class = Station
  @compare_class = Location
end
