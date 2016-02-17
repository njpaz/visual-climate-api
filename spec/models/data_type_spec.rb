require 'rails_helper'

RSpec.describe DataType, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  let(:type_response) do
    create_response(1460, true)
  end

  let(:category_response) do
    create_response(20)
  end

  let(:location_response) do
    create_response(20, true)
  end

  before do
    stub_response(type_response, 'datatypes')
    stub_response(category_response, 'datacategories')
    stub_response(location_response, 'locations')

    datacategory_results = category_response[:results].map { |result| result[:id] }

    max = 0
    datacategory_results.each do |result|
      min = max
      max += 73

      results = type_response[:results][min...max] || []
      response = { metadata: { resultset: { count: results.length } }, results: results }

      stub_request(:get, "http://ncdc.noaa.gov/cdo-web/api/v2/datatypes/?limit=1000&datacategoryid=#{result}").
        with(headers: {'Token'=>Rails.application.secrets.NOAA_API_KEY}).
        to_return(status: 200, body: response.to_json, headers: {:content_type => 'application/json'})
    end

    location_results = location_response[:results].map { |result| result[:id] }

    max = 0
    location_results.each do |result|
      min = max
      max += 73

      results = type_response[:results][min...max] || []
      response = { metadata: { resultset: { count: results.length } }, results: results }

      stub_request(:get, "http://ncdc.noaa.gov/cdo-web/api/v2/datatypes/?limit=1000&locationid=#{result}").
        with(headers: {'Token'=>Rails.application.secrets.NOAA_API_KEY}).
        to_return(status: 200, body: response.to_json, headers: {:content_type => 'application/json'})
    end
  end

  context 'populate' do
    it 'retrieves all of the datatypes and creates a record for each in the data_types table' do
      DataType.populate

      first_result = DataType.find_by(identifier: type_response[:results][0][:id])
      min_date = Date.strptime(type_response[:results][0][:mindate], '%Y-%m-%d')

      expect(DataType.count).to eq(type_response[:results].length)
      expect(first_result.name).to eq(type_response[:results][0][:name])
      expect(first_result.min_date).to eq(min_date)
    end

    it 'only creates records if they do not exist' do
      DataType.create(identifier: type_response[:results][0][:id])
      DataType.populate

      expect(DataType.count).to eq(type_response[:metadata][:resultset][:count])
    end
  end

  context 'populate_belongs_to' do
    it 'retrieves all data set ids and inserts them into the appropriate data category record' do
      DataType.populate
      DataCategory.populate
      Location.populate
      DataType.populate_belongs_to

      expect(DataType.pluck(:data_category_id).include?(nil)).to be_falsey
      expect(DataType.pluck(:location_id).include?(nil)).to be_falsey
    end
  end
end
