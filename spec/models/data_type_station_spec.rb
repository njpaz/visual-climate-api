require 'rails_helper'

RSpec.describe DataTypeStation, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  let(:datatype_response) do
    create_response(62, true)
  end

  let(:station_response) do
    create_response(107, true)
  end

  let(:result_count) do
    {}
  end

  before do
    stub_response(datatype_response, 'datatypes')
    stub_response(station_response, 'stations')

    datatype_results = datatype_response[:results].map { |result| result[:id] }

    max = 0
    datatype_results.each do |result|
      min = max
      max += 2

      results = station_response[:results][min...max] || []
      response = { metadata: { resultset: { count: results.length } }, results: results }
      result_count[result] = results.map { |res| res[:id] }

      stub_request(:get, "http://ncdc.noaa.gov/cdo-web/api/v2/stations/?datatypeid=#{result}&limit=1000").
        with(headers: {'Token'=>Rails.application.secrets.NOAA_API_KEY}).
        to_return(status: 200, body: response.to_json, headers: {:content_type => 'application/json'})
    end
  end

  context 'populate_joins' do
    it 'retrieves the relevant data and creates a record for each in the data_set_location_categories table' do
      DataType.populate
      Station.populate
      DataTypeStation.populate_joins

      first_type = DataType.first
      first_results = result_count[first_type.identifier]

      third_type = DataType.third
      third_results = result_count[third_type.identifier]

      expect(first_type.stations.pluck(:identifier)).to eq(first_results)
      expect(third_type.stations.pluck(:identifier)).to eq(third_results)
    end
  end
end
