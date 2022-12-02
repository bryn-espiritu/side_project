class CityMunicipality < ApplicationRecord
  belongs_to :province
  has_many :barangays
  has_many :addresses, class_name: 'Address', foreign_key: 'city_municipality_id'
end
