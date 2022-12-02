class ProvinceSerializer < ActiveModel::Serializer
  attributes :id, :name, :code
end

def region
  object.region.name
end
