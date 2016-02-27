namespace :populate do
  desc "Populates the database"
  task start: :environment do
    RetryPopulateJob.perform_later DataCategory.name, 'populate_belongs_to'
    RetryPopulateJob.perform_later DataType.name, 'populate_belongs_to'
    RetryPopulateJob.perform_later Location.name, 'populate_belongs_to'
    RetryPopulateJob.perform_later LocationCategory.name, 'populate_belongs_to'
    RetryPopulateJob.perform_later Station.name, 'populate_belongs_to'

    RetryPopulateJob.perform_later DataCategoryLocation.name, 'populate_joins'
    RetryPopulateJob.perform_later DataCategoryStation.name, 'populate_joins'
    RetryPopulateJob.perform_later DataSetDataType.name, 'populate_joins'
    RetryPopulateJob.perform_later DataSetLocationCategory.name, 'populate_joins'
    RetryPopulateJob.perform_later DataSetLocation.name, 'populate_joins'
    RetryPopulateJob.perform_later DataSetStation.name, 'populate_joins'
    RetryPopulateJob.perform_later DataTypeStation.name, 'populate_joins'
  end

end
