class API::LocationCategorySerializer < ActiveModel::Serializer
  attributes :id, :identifier, :name, :data_set_id

  has_many :locations, embed: :ids
end
