require 'rails_helper'

RSpec.describe DataCategoryDataSet, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  let(:dataset_response) do
    create_response(7, true)
  end

  let(:datacategory_response) do
    create_response(13)
  end

  let(:result_count) do
    {}
  end

  before do
    stub_response(dataset_response, 'datasets')
    stub_response(datacategory_response, 'datacategories')

    dataset_results = dataset_response[:results].map { |result| result[:id] }

    max = 0
    dataset_results.each do |result|
      min = max
      max += 2

      results = datacategory_response[:results][min...max] || []
      response = { metadata: { resultset: { count: results.length } }, results: results }
      result_count[result] = results.map { |res| res[:id] }

      stub_request(:get, "http://ncdc.noaa.gov/cdo-web/api/v2/datacategories/?datasetid=#{result}&limit=1000").
        with(headers: {'Token'=>Rails.application.secrets.NOAA_API_KEY}).
        to_return(status: 200, body: response.to_json, headers: {:content_type => 'application/json'})
    end
  end

  context 'populate_joins' do
    it 'retrieves the relevant data and creates a record for each in the data_category_data_sets table' do
      DataSet.populate
      DataCategory.populate
      DataCategoryDataSet.populate_joins

      first_set = DataSet.first
      first_results = result_count[first_set.identifier]

      third_set = DataSet.third
      third_results = result_count[third_set.identifier]

      expect(first_set.data_categories.pluck(:identifier)).to eq(first_results)
      expect(third_set.data_categories.pluck(:identifier)).to eq(third_results)
    end
  end
end
