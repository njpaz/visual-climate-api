require 'rails_helper'

RSpec.describe LocationCategory, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  context 'populate', vcr: { cassette_name: 'import_locationcategories' } do
    it 'retrieves all of the locationcategories and creates a record for each in the data_sets table' do
      LocationCategory.populate

      response = noaa_sync.locationcategories
      tested_response = response['results'][2]
      location_category = LocationCategory.find_by(identifier: tested_response['id'])

      expect(LocationCategory.count).to eq(response['results'].length)
      expect(location_category).to_not be_nil
      expect(location_category.name).to eq(tested_response['name'])
    end

    it 'only creates records if they do not exist' do
      LocationCategory.create(identifier: 'CITY')
      LocationCategory.populate

      expect(LocationCategory.count).to eq(12)
    end
  end
end
