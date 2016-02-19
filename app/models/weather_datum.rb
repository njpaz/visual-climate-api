class WeatherDatum < ActiveRecord::Base
  belongs_to :data_set
  belongs_to :data_type
  belongs_to :station

  def self.get_dataset_data(datasetid:, startdate:, enddate:, params: {})
    data_set = DataSet.find_by(identifier: datasetid)
    import_data(data_set: data_set, startdate: startdate, enddate: enddate, params: params)
    where(data_set: data_set, date: startdate.to_date..enddate.to_date)
  end

private

  def self.get_results(results: [], count:, sync:, data_set:, startdate:, enddate:, params:)
    offset = 1001

    while offset <= count
      data = sync.data(datasetid: data_set.identifier, startdate: startdate, enddate: enddate, params: params)
      results += data['results']
      offset += 1000
    end

    results
  end

  def self.format_inserted_data(results:, data_set:)
    inserted_data = []

    results.each do |weather_data|
      data_type = DataType.find_by(identifier: weather_data['datatype'])
      station = Station.find_by(identifier: weather_data['station'])

      if find_by(data_type: data_type, station: station, data_set: data_set, date: weather_data['date']).nil?
        inserted_data << [data_set.id, data_type.id, station.id, weather_data['date'], weather_data['attributes'], weather_data['value']]
      end
    end

    inserted_data
  end

  def self.import_data(data_set:, startdate:, enddate:, params: {})
    params.merge!({'limit' => 1000})

    sync = NOAASync.new
    data = sync.data(datasetid: data_set.identifier, startdate: startdate, enddate: enddate, params: params)

    count = data['metadata']['resultset']['count']
    results = get_results(results: data['results'], count: count, sync: sync, data_set: data_set, startdate: startdate, enddate: enddate, params: params)
    inserted_data = format_inserted_data(results: results, data_set: data_set)

    import [:data_set_id, :data_type_id, :station_id, :date, :data_attributes, :value], inserted_data
  end
end
