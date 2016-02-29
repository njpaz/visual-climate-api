namespace :initial do
  desc "Populates the database with dummy information"
  task seed: :environment do
    Station.create([
      {identifier: "GHCND:AYM00089606", name: "VOSTOK, AY"},
      {identifier: "GHCND:USC00042319", name: "DEATH VALLEY, CA, US"}
    ])

    DataType.create([
      {identifier: "EMNT", name: "Extreme minimum daily temperature"},
      {identifier: "EMXT", name: "Extreme maximum daily temperature"},
    ])

    dates = [
      Date.new(2015, 6, 1),
      Date.new(2015, 7, 1),
      Date.new(2015, 8, 1),
      Date.new(2015, 9, 1),
      Date.new(2015, 10, 1),
      Date.new(2015, 11, 1),
      Date.new(2015, 12, 1)
    ]

    dates.each do |date|
      WeatherDatum.create(date: date, station: Station.first, data_type: DataType.first, value: (rand * 50).round)
      WeatherDatum.create(date: date, station: Station.first, data_type: DataType.last, value: (rand * 50).round)
      WeatherDatum.create(date: date, station: Station.last, data_type: DataType.first, value: (rand * 50).round)
      WeatherDatum.create(date: date, station: Station.last, data_type: DataType.last, value: (rand * 50).round)
    end
  end

end
