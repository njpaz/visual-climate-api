require 'rails_helper'

RSpec.describe DataCategoryDataType, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  context 'populate_joins', vcr: { cassette_name: 'join_data_category_data_types' } do
    it 'retrieves the relevant data and creates a record for each in the data_category_data_types table' do
      DataCategory.populate
      DataType.populate
      DataCategoryDataType.populate_joins

      first_set = DataCategory.first
      third_set = DataCategory.third
      first_set_sync = noaa_sync.datatypes(params: {'datacategoryid'=>first_set.identifier})
      third_set_sync = noaa_sync.datatypes(params: {'datacategoryid'=>third_set.identifier})

      expect(DataCategoryDataType.count).to eq(1460)
      expect(first_set.data_category_data_types.count).to eq(first_set_sync['metadata']['resultset']['count'])
      expect(third_set.data_category_data_types.count).to eq(third_set_sync['metadata']['resultset']['count'])
    end
  end
end
