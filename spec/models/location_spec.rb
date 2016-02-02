require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  context 'import', vcr: { cassette_name: 'import_locations' } do
    it 'retrieves all of the locations and creates a record for each in the locations table' do
      Location.do_import

      response = noaa_sync.locations
      tested_response = response['results'][7]
      location = Location.find_by(identifier: tested_response['id'])

      expect(Location.count).to eq(response['metadata']['resultset']['count'])
      expect(location).to_not be_nil
      expect(location.name).to eq(tested_response['name'])
      expect(location.min_date).to eq(Date.strptime(tested_response['mindate'], '%Y-%m-%d'))
    end

    it 'only creates records if they do not exist' do
      Location.create(identifier: 'CITY:AG000002')
      Location.do_import

      expect(Location.count).to eq(38849)
    end
  end
end
