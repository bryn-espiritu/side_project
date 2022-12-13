class Address < ApplicationRecord
  ADDRESS_LIMIT = 5
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :region, class_name: 'Region', foreign_key: 'region_id'
  belongs_to :province, class_name: 'Province', foreign_key: 'province_id'
  belongs_to :city_municipality, class_name: 'CityMunicipality', foreign_key: 'city_municipality_id'
  belongs_to :barangay, class_name: 'Barangay', foreign_key: 'barangay_id'
  before_create :default_first_address
  after_save :move_default
  enum genre: { home: 0, office: 1 }

  private

  def default_first_address
    if user.addresses.empty?
      self.is_default = true
    else
      self.is_default = false
    end
  end

  def move_default
    if is_default
      user.addresses.where('id != ?', id).update_all(is_default: false)
    end
  end

  def address_limit
    self.user.addresses.reload.count >= ADDRESS_LIMIT
    error.add(:base, "ERROR: Address limit reached. Edit or delete unnecessary addresses")
  end
end
