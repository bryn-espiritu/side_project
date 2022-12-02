class Region < ApplicationRecord
  has_many :provinces
  has_many :addresses, class_name: 'Address', foreign_key: 'region_id'
end
