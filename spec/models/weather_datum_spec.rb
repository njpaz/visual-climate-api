require 'rails_helper'

RSpec.describe WeatherDatum, type: :model do
  let(:noaa_sync) do
    NOAASync.new
  end

  let(:datatype_response) do
    create_response(6, true)
  end

  let(:station_response) do
    create_response(12, true)
  end

  let(:dataset_response) do
    create_response(3, true)
  end

  let(:startdate) do
    Date.new(2009, 10, 1).strftime('%Y-%m-%dT%H:%M:%S')
  end

  let(:data_response) do
    station_identifiers = station_response[:results].map { |sr| sr[:id] }
    datatype_identifiers = datatype_response[:results].map { |dtr| dtr[:id] }
    response = { metadata: { resultset: { count: 72 } }, results: [] }

    station_identifiers.each do |station_identifier|
      datatype_identifiers.each do |datatype_identifier|
        response[:results] << { date: startdate, datatype: datatype_identifier, station: station_identifier, attributes: ',,S,', value: (rand * 400).round }
      end
    end

    response
  end

  let(:first_datasetid) do
    dataset_response[:results][0][:id]
  end

  before do
    stub_response(datatype_response, 'datatypes')
    stub_response(station_response, 'stations')
    stub_response(dataset_response, 'datasets')

    stub_request(:get, "http://ncdc.noaa.gov/cdo-web/api/v2/data?datasetid=#{first_datasetid}&enddate=#{startdate}&startdate=#{startdate}").
      with(headers: {'Token'=>Rails.application.secrets.NOAA_API_KEY}).
      to_return(status: 200, body: data_response.to_json, headers: {:content_type => 'application/json'})
  end

  context 'get_dataset_data' do
    it 'inserts all data into the database' do
      DataType.populate
      Station.populate
      DataSet.populate

      WeatherDatum.get_dataset_data(datasetid: first_datasetid, startdate: startdate, enddate: startdate)

      expect(WeatherDatum.count).to eq(data_response[:metadata][:resultset][:count])
    end

    it 'only inserts missing data' do
      DataType.populate
      Station.populate
      DataSet.populate

      WeatherDatum.get_dataset_data(datasetid: first_datasetid, startdate: startdate, enddate: startdate)
      WeatherDatum.get_dataset_data(datasetid: first_datasetid, startdate: startdate, enddate: startdate)

      expect(WeatherDatum.count).to eq(data_response[:metadata][:resultset][:count])
    end

    it 'returns the relevant data' do
      DataType.populate
      Station.populate
      DataSet.populate

      returned_data = WeatherDatum.get_dataset_data(datasetid: first_datasetid, startdate: startdate, enddate: startdate)

      expect(returned_data.count).to eq(72)
      expect(returned_data.pluck(:data_set_id).uniq.count).to eq(1)
      expect(returned_data.first.data_set.identifier).to eq(first_datasetid)
    end
  end
end
