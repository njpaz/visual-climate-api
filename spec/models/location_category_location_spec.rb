require 'rails_helper'

RSpec.describe LocationCategoryLocation, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  let(:locationcategory_response) do
    create_response(12, true)
  end

  let(:location_response) do
    create_response(107, true)
  end

  let(:result_count) do
    {}
  end

  before do
    stub_response(locationcategory_response, 'locationcategories')
    stub_response(location_response, 'locations')

    dataset_results = locationcategory_response[:results].map { |result| result[:id] }

    max = 0
    dataset_results.each do |result|
      min = max
      max += 2

      results = location_response[:results][min...max] || []
      response = { metadata: { resultset: { count: results.length } }, results: results }
      result_count[result] = results.map { |res| res[:id] }

      stub_request(:get, "http://ncdc.noaa.gov/cdo-web/api/v2/locations/?locationcategoryid=#{result}&limit=1000").
        with(headers: {'Token'=>Rails.application.secrets.NOAA_API_KEY}).
        to_return(status: 200, body: response.to_json, headers: {:content_type => 'application/json'})
    end
  end

  context 'populate_joins' do
    it 'retrieves the relevant data and creates a record for each in the data_set_location_categories table' do
      LocationCategory.populate
      Location.populate
      LocationCategoryLocation.populate_joins

      first_category = LocationCategory.first
      first_results = result_count[first_category.identifier]

      third_category = LocationCategory.third
      third_results = result_count[third_category.identifier]

      expect(first_category.locations.pluck(:identifier)).to eq(first_results)
      expect(third_category.locations.pluck(:identifier)).to eq(third_results)
    end
  end
end
