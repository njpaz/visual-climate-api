class WeatherDatum < ActiveRecord::Base
  belongs_to :data_set
  belongs_to :data_type
  belongs_to :station

  def self.get_dataset_data(datasetid:, startdate:, enddate:)
    data_set = DataSet.find_by(identifier: datasetid)
    data = where(data_set: data_set, date: startdate.to_date..enddate.to_date)

    if data.count == 0
      import_data(data_set: data_set, startdate: startdate, enddate: enddate)
      data = where(data_set: data_set, date: startdate.to_date..enddate.to_date)
    end

    data
  end

private

  def self.import_data(data_set:, startdate:, enddate:)
    sync = NOAASync.new
    data = sync.data(datasetid: data_set.identifier, startdate: startdate, enddate: enddate)

    inserted_data = data['results'].map do |weather_data|
      data_type = DataType.find_by(identifier: weather_data['datatype'])
      station = Station.find_by(identifier: weather_data['station'])

      [data_set.id, data_type.id, station.id, weather_data['date'], weather_data['attributes'], weather_data['value']]
    end

    import [:data_set_id, :data_type_id, :station_id, :date, :data_attributes, :value], inserted_data
  end
end
