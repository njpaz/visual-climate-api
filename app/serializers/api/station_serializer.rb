class API::StationSerializer < ActiveModel::Serializer
  attributes :id, :identifier, :latitude, :longitude, :name, :elevation_unit, :min_date, :max_date, :elevation, :titlecase_name
end
