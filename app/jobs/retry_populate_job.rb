class RetryPopulateJob < ActiveJob::Base
  queue_as :default

  def perform(location, location_method)
    location.constantize.send(location_method)
  end
end
