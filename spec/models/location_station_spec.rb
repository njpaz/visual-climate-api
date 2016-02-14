require 'rails_helper'

RSpec.describe LocationStation, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  let(:location_response) do
    create_response(102, true)
  end

  let(:station_response) do
    create_response(107, true)
  end

  let(:result_count) do
    {}
  end

  before do
    stub_response(location_response, 'locations')
    stub_response(station_response, 'stations')

    location_results = location_response[:results].map { |result| result[:id] }

    max = 0
    location_results.each do |result|
      min = max
      max += 2

      results = station_response[:results][min...max] || []
      response = { metadata: { resultset: { count: results.length } }, results: results }
      result_count[result] = results.map { |res| res[:id] }

      stub_request(:get, "http://ncdc.noaa.gov/cdo-web/api/v2/stations/?locationid=#{result}&limit=1000").
        with(headers: {'Token'=>Rails.application.secrets.NOAA_API_KEY}).
        to_return(status: 200, body: response.to_json, headers: {:content_type => 'application/json'})
    end
  end

  context 'populate_joins' do
    it 'retrieves the relevant data and creates a record for each in the data_set_location_categories table' do
      Location.populate
      Station.populate
      LocationStation.populate_joins

      first_location = Location.first
      first_results = result_count[first_location.identifier]

      third_location = Location.third
      third_results = result_count[third_location.identifier]

      expect(first_location.stations.pluck(:identifier)).to eq(first_results)
      expect(third_location.stations.pluck(:identifier)).to eq(third_results)
    end
  end
end
