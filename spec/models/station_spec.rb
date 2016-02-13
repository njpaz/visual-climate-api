require 'rails_helper'

RSpec.describe Station, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  let(:response) do
    create_response(12442, true)
  end

  before do
    stub_response(response, 'stations')
  end

  context 'populate' do
    it 'retrieves all of the stations and creates a record for each in the stations table' do
      Station.populate

      first_result = Station.find_by(identifier: response[:results][0][:id])
      min_date = Date.strptime(response[:results][0][:mindate], '%Y-%m-%d')

      expect(Station.count).to eq(response[:results].length)
      expect(first_result.name).to eq(response[:results][0][:name])
      expect(first_result.min_date).to eq(min_date)
    end

    it 'only creates records if they do not exist' do
      Station.create(identifier: response[:results][0][:id])
      Station.populate

      expect(Station.count).to eq(response[:metadata][:resultset][:count])
    end
  end
end
