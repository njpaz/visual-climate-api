require 'rails_helper'

RSpec.describe LocationCategory, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  let(:response) do
    create_response(12)
  end

  before do
    stub_response(response, 'locationcategories')
  end

  context 'populate' do
    it 'retrieves all of the locationcategories and creates a record for each in the data_sets table' do
      LocationCategory.populate

      first_result = LocationCategory.find_by(identifier: response[:results][0][:id])

      expect(LocationCategory.count).to eq(response[:results].length)
      expect(first_result.name).to eq(response[:results][0][:name])
    end

    it 'only creates records if they do not exist' do
      LocationCategory.create(identifier: response[:results][0][:id])
      LocationCategory.populate

      expect(LocationCategory.count).to eq(response[:metadata][:resultset][:count])
    end
  end
end
