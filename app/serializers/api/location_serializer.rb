class API::LocationSerializer < ActiveModel::Serializer
  attributes :id, :identifier, :min_date, :max_date, :name, :location_category_id
end
