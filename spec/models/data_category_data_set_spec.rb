require 'rails_helper'

RSpec.describe DataCategoryDataSet, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  context 'populate_joins', vcr: { cassette_name: 'join_data_category_data_sets' } do
    it 'retrieves the relevant data and creates a record for each in the data_category_data_sets table' do
      DataSet.populate
      DataCategory.populate
      DataCategoryDataSet.populate_joins

      first_set = DataSet.first
      first_set_sync = noaa_sync.datacategories(params: {'datasetid'=>first_set.identifier})
      third_set = DataSet.third
      third_set_sync = noaa_sync.datacategories(params: {'datasetid'=>third_set.identifier})

      expect(DataCategoryDataSet.count).to eq(63)
      expect(first_set.data_category_data_sets.count).to eq(first_set_sync['metadata']['resultset']['count'])
      expect(third_set.data_category_data_sets.count).to eq(third_set_sync['metadata']['resultset']['count'])
    end
  end
end
