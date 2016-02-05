require 'rails_helper'

RSpec.describe DataSetLocationCategory, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  context 'populate_joins', vcr: { cassette_name: 'join_data_set_location_categories' } do
    it 'retrieves the relevant data and creates a record for each in the data_set_location_categories table' do
      DataSet.populate
      LocationCategory.populate
      DataSetLocationCategory.populate_joins

      first_set = DataSet.first
      first_set_sync = noaa_sync.locationcategories(params: {'datasetid'=>first_set.identifier})
      third_set = DataSet.third
      third_set_sync = noaa_sync.locationcategories(params: {'datasetid'=>third_set.identifier})

      expect(DataSetLocationCategory.count).to eq(132)
      expect(first_set.data_set_location_categories.count).to eq(first_set_sync['metadata']['resultset']['count'])
      expect(third_set.data_set_location_categories.count).to eq(third_set_sync['metadata']['resultset']['count'])
    end
  end
end
