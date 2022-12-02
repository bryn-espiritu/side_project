class Province < ApplicationRecord
  belongs_to :region
  has_many :city_municipalities
  has_many :addresses, class_name: 'Address', foreign_key: 'province_id'
end
