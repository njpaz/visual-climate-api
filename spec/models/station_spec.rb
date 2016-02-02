require 'rails_helper'

RSpec.describe Station, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  context 'import', vcr: { cassette_name: 'import_stations' } do
    it 'retrieves all of the stations and creates a record for each in the stations table' do
      Station.do_import

      response = noaa_sync.stations(params: { 'limit' => 1000 })
      tested_response = response['results'][7]
      station = Station.find_by(identifier: tested_response['id'])

      expect(Station.count).to eq(response['metadata']['resultset']['count'])
      expect(station).to_not be_nil
      expect(station.name).to eq(tested_response['name'])
      expect(station.min_date).to eq(Date.strptime(tested_response['mindate'], '%Y-%m-%d'))
    end

    it 'only creates records if they do not exist' do
      Station.create(identifier: 'COOP:010008')
      Station.do_import

      expect(Station.count).to eq(124421)
    end
  end
end
