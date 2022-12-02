class Barangay < ApplicationRecord
  belongs_to :city_municipality
  has_many :addresses, class_name: 'Address', foreign_key: 'barangay_id'
end
