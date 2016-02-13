require 'rails_helper'

RSpec.describe DataSet, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  let(:response) do
    create_response(11, true)
  end

  before do
    stub_response(response, 'datasets')
  end

  context 'populate' do
    it 'retrieves all of the datasets and creates a record for each in the data_sets table' do
      DataSet.populate

      first_result = DataSet.find_by(identifier: response[:results][0][:id])
      min_date = Date.strptime(response[:results][0][:mindate], '%Y-%m-%d')

      expect(DataSet.count).to eq(response[:results].length)
      expect(first_result.name).to eq(response[:results][0][:name])
      expect(first_result.min_date).to eq(min_date)
    end

    it 'only creates records if they do not exist' do
      DataSet.create(identifier: response[:results][0][:id])
      DataSet.populate

      expect(DataSet.count).to eq(response[:metadata][:resultset][:count])
    end
  end
end
