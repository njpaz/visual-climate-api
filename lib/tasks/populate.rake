namespace :populate do
  desc "Populates the database"
  task start: :environment do
    DataCategory.populate_belongs_to
    DataType.populate_belongs_to
    Location.populate_belongs_to
    LocationCategory.populate_belongs_to
    Station.populate_belongs_to

    DataCategoryLocation.populate_joins
    DataCategoryStation.populate_joins
    DataSetDataType.populate_joins
    DataSetLocationCategory.populate_joins
    DataSetLocation.populate_joins
    DataSetStation.populate_joins
    DataTypeStation.populate_joins
  end

end
