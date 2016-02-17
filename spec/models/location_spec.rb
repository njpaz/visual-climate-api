require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  let(:location_response) do
    create_response(8849, true)
  end

  let(:category_response) do
    create_response(12)
  end

  before do
    stub_response(location_response, 'locations')
    stub_response(category_response, 'locationcategories')

    category_results = category_response[:results].map { |result| result[:id] }

    max = 0
    category_results.each do |result|
      min = max
      max += 738

      results = location_response[:results][min...max] || []
      response = { metadata: { resultset: { count: results.length } }, results: results }

      stub_request(:get, "http://ncdc.noaa.gov/cdo-web/api/v2/locations/?limit=1000&locationcategoryid=#{result}").
        with(headers: {'Token'=>Rails.application.secrets.NOAA_API_KEY}).
        to_return(status: 200, body: response.to_json, headers: {:content_type => 'application/json'})
    end
  end

  context 'populate' do
    it 'retrieves all of the locations and creates a record for each in the locations table' do
      Location.populate

      first_result = Location.find_by(identifier: location_response[:results][0][:id])
      min_date = Date.strptime(location_response[:results][0][:mindate], '%Y-%m-%d')

      expect(Location.count).to eq(location_response[:results].length)
      expect(first_result.name).to eq(location_response[:results][0][:name])
      expect(first_result.min_date).to eq(min_date)
    end

    it 'only creates records if they do not exist' do
      Location.create(identifier: location_response[:results][0][:id])
      Location.populate

      expect(Location.count).to eq(location_response[:metadata][:resultset][:count])
    end
  end

  context 'populate_belongs_to' do
    it 'retrieves all location category ids and inserts them into the appropriate location record' do
      Location.populate
      LocationCategory.populate
      Location.populate_belongs_to

      expect(Location.pluck(:location_category_id).include?(nil)).to be_falsey
    end
  end
end
