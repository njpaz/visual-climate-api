require 'rails_helper'

RSpec.describe DataSet, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  context 'populate', vcr: { cassette_name: 'import_datasets' } do
    it 'retrieves all of the datasets and creates a record for each in the data_sets table' do
      DataSet.populate

      response = noaa_sync.datasets(params: { 'limit' => 1000 })
      tested_response = response['results'][7]
      data_set = DataSet.find_by(identifier: tested_response['id'])

      expect(DataSet.count).to eq(response['results'].length)
      expect(data_set).to_not be_nil
      expect(data_set.name).to eq(tested_response['name'])
      expect(data_set.min_date).to eq(Date.strptime(tested_response['mindate'], '%Y-%m-%d'))
    end

    it 'only creates records if they do not exist' do
      DataSet.create(identifier: 'ANNUAL')
      DataSet.populate

      expect(DataSet.count).to eq(11)
    end
  end
end
