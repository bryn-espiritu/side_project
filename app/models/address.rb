class Address < ApplicationRecord
  belongs_to :user, class_name:  'User', foreign_key: 'user_id'
  belongs_to :region, class_name: 'Region', foreign_key: 'region_id'
  belongs_to :province, class_name: 'Province', foreign_key: 'province_id'
  belongs_to :city_municipality, class_name: 'CityMunicipality', foreign_key: 'city_municipality_id'
  belongs_to :barangay, class_name: 'Barangay', foreign_key: 'barangay_id'
  enum genre: { home: 0, office: 1 }
end
