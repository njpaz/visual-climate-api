require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  let(:response) do
    create_response(8849, true)
  end

  before do
    stub_response(response, 'locations')
  end

  context 'populate' do
    it 'retrieves all of the locations and creates a record for each in the locations table' do
      Location.populate

      first_result = Location.find_by(identifier: response[:results][0][:id])
      min_date = Date.strptime(response[:results][0][:mindate], '%Y-%m-%d')

      expect(Location.count).to eq(response[:results].length)
      expect(first_result.name).to eq(response[:results][0][:name])
      expect(first_result.min_date).to eq(min_date)
    end

    it 'only creates records if they do not exist' do
      Location.create(identifier: response[:results][0][:id])
      Location.populate

      expect(Location.count).to eq(response[:metadata][:resultset][:count])
    end
  end
end
