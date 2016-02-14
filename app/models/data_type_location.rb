class DataTypeLocation < ActiveRecord::Base
  include PopulateJoin

  belongs_to :data_type
  belongs_to :location

  @call_class = Location
  @compare_class = DataType
end
