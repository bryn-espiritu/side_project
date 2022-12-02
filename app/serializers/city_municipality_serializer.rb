class CityMunicipalitySerializer < ActiveModel::Serializer
  attributes :id, :name, :code
end

def province
  object.province.name
end