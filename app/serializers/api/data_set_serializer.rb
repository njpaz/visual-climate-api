class API::DataSetSerializer < ActiveModel::Serializer
  attributes :id, :identifier, :min_date, :max_date, :name
end
