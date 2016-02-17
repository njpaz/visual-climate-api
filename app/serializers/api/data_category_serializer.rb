class API::DataCategorySerializer < ActiveModel::Serializer
  attributes :id, :identifier, :name, :data_set_id
end
