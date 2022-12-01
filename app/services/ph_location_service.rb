class PhLocationService
  attr_reader :url
  def initialize
    @url = 'https://psgc.gitlab.io/api'
  end
  def fetch_regions
    response = RestClient.get("#{url}/regions")
    regions = JSON.parse(response.body)
    regions.each do |region|
      Region.find_or_create_by(code: region['code'], name: region['name'], region_name: region['regionName'])
    end
  end
  def fetch_provinces
    response = RestClient.get("#{url}/provinces")
    provinces = JSON.parse(response.body)
    provinces.each do |province|
      region = Region.find_by_code(province['regionCode'])
      Province.find_or_create_by(code: province['code'], name: province['name'], region: region)
    end
    response = RestClient.get("#{url}/districts")
    districts = JSON.parse(response.body)
    districts.each do |district|
      region = Region.find_by_code(district['regionCode'])
      Province.find_or_create_by(code: district['code'], name: district['name'], region: region)
    end
  end

  def fetch_city_municipalitites
    response = RestClient.get("#{url}/cities-municipalities")
    city_municipalities = JSON.parse(response.body)
    city_municipalities.each do |city|
      if city['provinceCode']
        province = Province.find_by_code(city['provinceCode'])
        CityMunicipality.find_or_create_by(code: city['code'], name: city['name'], province: province)
      elsif city['districtCode']
        province = Province.find_by_code(city['districtCode'])
        CityMunicipality.find_or_create_by(code: city['code'], name: city['name'], province: province)
      else
        if city['name'] == "City of Isabela"
          province = Province.find_by_name('Basilan')
          CityMunicipality.find_or_create_by(code: city['code'], name: city['name'], province: province)
        elsif city['name'] == "City of Cotabato"
          province = Province.find_by_name('Maguindanao')
          CityMunicipality.find_or_create_by(code: city['code'], name: city['name'], province: province)
        end
      end
    end
  end
    def fetch_barangays
      response = RestClient.get("#{url}/barangays")
      barangays = JSON.parse(response.body)
      barangays.each do |brgy|
        if brgy['cityCode']
          city_municipality = CityMunicipality.find_by_code(brgy['cityCode'])
        else
          city_municipality = CityMunicipality.find_by_code(brgy['municipalityCode'])
        end
        Barangay.find_or_create_by(code: brgy["code"], name: brgy["name"], city_municipality: city_municipality)
      end
    end
  end