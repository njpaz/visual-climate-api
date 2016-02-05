require 'rails_helper'

RSpec.describe DataType, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  context 'populate', vcr: { cassette_name: 'import_datatypes' } do
    it 'retrieves all of the datatypes and creates a record for each in the data_types table' do
      DataType.populate

      response = noaa_sync.datatypes
      tested_response = response['results'][2]
      data_type = DataType.find_by(identifier: tested_response['id'])

      expect(DataType.count).to eq(response['metadata']['resultset']['count'])
      expect(data_type).to_not be_nil
      expect(data_type.min_date).to eq(Date.strptime(tested_response['mindate'], '%Y-%m-%d'))
    end

    it 'only creates records if they do not exist' do
      DataType.create(identifier: 'ACMC')
      DataType.populate

      expect(DataType.count).to eq(1461)
    end
  end
end
