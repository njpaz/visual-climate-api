require 'rails_helper'

RSpec.describe Station, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  let(:station_response) do
    create_response(1500, true)
  end

  let(:location_response) do
    create_response(15, true)
  end

  before do
    stub_response(station_response, 'stations')
    stub_response(location_response, 'locations')

    location_results = location_response[:results].map { |result| result[:id] }

    max = 0
    location_results.each do |result|
      min = max
      max += 100

      results = station_response[:results][min...max] || []
      response = { metadata: { resultset: { count: results.length } }, results: results }

      stub_request(:get, "http://ncdc.noaa.gov/cdo-web/api/v2/stations/?limit=1000&locationid=#{result}").
        with(headers: {'Token'=>Rails.application.secrets.NOAA_API_KEY}).
        to_return(status: 200, body: response.to_json, headers: {:content_type => 'application/json'})
    end
  end

  context 'populate' do
    it 'retrieves all of the stations and creates a record for each in the stations table' do
      Station.populate

      first_result = Station.find_by(identifier: station_response[:results][0][:id])
      min_date = Date.strptime(station_response[:results][0][:mindate], '%Y-%m-%d')

      expect(Station.count).to eq(station_response[:results].length)
      expect(first_result.name).to eq(station_response[:results][0][:name])
      expect(first_result.min_date).to eq(min_date)
    end

    it 'only creates records if they do not exist' do
      Station.create(identifier: station_response[:results][0][:id])
      Station.populate

      expect(Station.count).to eq(station_response[:metadata][:resultset][:count])
    end
  end

  context 'populate_belongs_to' do
    it 'retrieves all location ids and inserts them into the appropriate station record' do
      Location.populate
      Station.populate
      Station.populate_belongs_to

      expect(Station.pluck(:location_id).include?(nil)).to be_falsey
      expect(Station.pluck(:location_id).uniq.length).to eq(15)
    end
  end
end
