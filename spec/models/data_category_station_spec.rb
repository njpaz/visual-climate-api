require 'rails_helper'

RSpec.describe DataCategoryStation, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  let(:station_response) do
    create_response(62, true)
  end

  let(:datacategory_response) do
    create_response(17)
  end

  let(:result_count) do
    {}
  end

  before do
    stub_response(station_response, 'stations')
    stub_response(datacategory_response, 'datacategories')

    datacategory_results = datacategory_response[:results].map { |result| result[:id] }

    max = 0
    datacategory_results.each do |result|
      min = max
      max += 2

      results = station_response[:results][min...max] || []
      response = { metadata: { resultset: { count: results.length } }, results: results }
      result_count[result] = results.map { |res| res[:id] }

      stub_request(:get, "http://ncdc.noaa.gov/cdo-web/api/v2/stations/?datacategoryid=#{result}&limit=1000").
        with(headers: {'Token'=>Rails.application.secrets.NOAA_API_KEY}).
        to_return(status: 200, body: response.to_json, headers: {:content_type => 'application/json'})
    end
  end

  context 'populate_joins' do
    it 'retrieves all of the relevant data' do
      Station.populate
      DataCategory.populate
      DataCategoryStation.populate_joins

      first_category = DataCategory.first
      first_results = result_count[first_category.identifier]

      third_category = DataCategory.third
      third_results = result_count[third_category.identifier]

      expect(first_category.stations.pluck(:identifier)).to eq(first_results)
      expect(third_category.stations.pluck(:identifier)).to eq(third_results)
    end
  end
end
