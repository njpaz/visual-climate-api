require 'rails_helper'

RSpec.describe DataCategory, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  context 'import', vcr: { cassette_name: 'import_datacategories' } do
    it 'retrieves all of the datacategories and creates a record for each in the data_categories table' do
      DataCategory.do_import

      response = noaa_sync.datacategories(params: { 'limit': 1000 })
      tested_response = response['results'][2]
      data_category = DataCategory.find_by(identifier: tested_response['id'])

      expect(DataCategory.count).to eq(response['results'].length)
      expect(data_category).to_not be_nil
      expect(data_category.name).to eq(tested_response['name'])
    end

    it 'only creates records if they do not exist' do
      DataCategory.create(identifier: 'ANNAGR')
      DataCategory.do_import

      expect(DataCategory.count).to eq(41)
    end
  end
end
