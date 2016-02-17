require 'rails_helper'

RSpec.describe LocationCategory, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  let(:category_response) do
    create_response(12)
  end

  let(:set_response) do
    create_response(4, true)
  end

  before do
    stub_response(category_response, 'locationcategories')
    stub_response(set_response, 'datasets')

    dataset_results = set_response[:results].map { |result| result[:id] }

    max = 0
    dataset_results.each do |result|
      min = max
      max += 3

      results = category_response[:results][min...max] || []
      response = { metadata: { resultset: { count: results.length } }, results: results }

      stub_request(:get, "http://ncdc.noaa.gov/cdo-web/api/v2/locationcategories/?limit=1000&datasetid=#{result}").
        with(headers: {'Token'=>Rails.application.secrets.NOAA_API_KEY}).
        to_return(status: 200, body: response.to_json, headers: {:content_type => 'application/json'})
    end
  end

  context 'populate' do
    it 'retrieves all of the locationcategories and creates a record for each in the data_sets table' do
      LocationCategory.populate

      first_result = LocationCategory.find_by(identifier: category_response[:results][0][:id])

      expect(LocationCategory.count).to eq(category_response[:results].length)
      expect(first_result.name).to eq(category_response[:results][0][:name])
    end

    it 'only creates records if they do not exist' do
      LocationCategory.create(identifier: category_response[:results][0][:id])
      LocationCategory.populate

      expect(LocationCategory.count).to eq(category_response[:metadata][:resultset][:count])
    end
  end

  context 'populate_belongs_to' do
    it 'retrieves all data set ids and inserts them into the appropriate data category record' do
      LocationCategory.populate
      DataSet.populate
      LocationCategory.populate_belongs_to

      expect(LocationCategory.pluck(:data_set_id).include?(nil)).to be_falsey
    end
  end
end
