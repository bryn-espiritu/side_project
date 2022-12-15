module ApplicationHelper
  def api_address(address)
    "#{address.street_address}, #{address.barangay.name}, #{address.city_municipality.name}, #{address.province.name}, #{address.region.name}"
  end
end
