class API::LocationCategorySerializer < ActiveModel::Serializer
  attributes :id, :identifier, :name

  has_many :locations, embed: :ids
end
