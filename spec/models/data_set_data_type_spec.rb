require 'rails_helper'

RSpec.describe DataSetDataType, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  context 'populate_joins', vcr: { cassette_name: 'join_data_sets_data_types' } do
    it 'retrieves the relevant data and creates a record for each in the data_set_data_types table' do
      DataSet.populate
      DataType.populate
      DataSetDataType.populate_joins

      first_set = DataSet.first
      first_set_sync = noaa_sync.datatypes(params: {'datasetid'=>first_set.identifier})
      third_set = DataSet.third
      third_set_sync = noaa_sync.datatypes(params: {'datasetid'=>third_set.identifier})

      expect(DataSetDataType.count).to eq(1474)
      expect(first_set.data_set_data_types.count).to eq(first_set_sync['metadata']['resultset']['count'])
      expect(third_set.data_set_data_types.count).to eq(third_set_sync['metadata']['resultset']['count'])
    end
  end
end
