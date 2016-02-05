class DataCategoryDataType < ActiveRecord::Base
  include PopulateJoin

  belongs_to :data_category
  belongs_to :data_type

  @call_class = DataType
  @compare_class = DataCategory
end
