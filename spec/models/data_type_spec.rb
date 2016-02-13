require 'rails_helper'

RSpec.describe DataType, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  let(:response) do
    create_response(1461, true)
  end

  before do
    stub_response(response, 'datatypes')
  end

  context 'populate' do
    it 'retrieves all of the datatypes and creates a record for each in the data_types table' do
      DataType.populate

      first_result = DataType.find_by(identifier: response[:results][0][:id])
      min_date = Date.strptime(response[:results][0][:mindate], '%Y-%m-%d')

      expect(DataType.count).to eq(response[:results].length)
      expect(first_result.name).to eq(response[:results][0][:name])
      expect(first_result.min_date).to eq(min_date)
    end

    it 'only creates records if they do not exist' do
      DataType.create(identifier: response[:results][0][:id])
      DataType.populate

      expect(DataType.count).to eq(response[:metadata][:resultset][:count])
    end
  end
end
