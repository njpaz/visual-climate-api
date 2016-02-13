require 'rails_helper'

RSpec.describe DataCategory, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  let(:response) do
    create_response(11)
  end

  before do
    stub_response(response, 'datacategories')
  end

  context 'populate' do
    it 'retrieves all of the datacategories and creates a record for each in the data_categories table' do
      DataCategory.populate

      first_result = DataCategory.find_by(identifier: response[:results][0][:id])

      expect(DataCategory.count).to eq(response[:results].length)
      expect(first_result.name).to eq(response[:results][0][:name])
    end

    it 'only creates records if they do not exist' do
      DataCategory.create(identifier: response[:results][0][:id])
      DataCategory.populate

      expect(DataCategory.count).to eq(response[:metadata][:resultset][:count])
    end
  end
end
