class Province < ApplicationRecord
  belongs_to :region
  has_many :city_municipalities
end
