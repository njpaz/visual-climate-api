class DataCategoryDataSet < ActiveRecord::Base
  include PopulateJoin

  belongs_to :data_category
  belongs_to :data_set

  @call_class = DataCategory
  @compare_class = DataSet
end
