class BarangaySerializer < ActiveModel::Serializer
  attributes :id, :name, :code
end

def city_municipality
  object.city_municipality.name
end
