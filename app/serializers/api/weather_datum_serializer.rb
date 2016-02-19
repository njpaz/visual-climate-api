class API::WeatherDatumSerializer < ActiveModel::Serializer
  attributes :id, :value, :date, :data_set_id, :data_type_id, :station_id, :in_fahrenheit, :in_celsius
end
