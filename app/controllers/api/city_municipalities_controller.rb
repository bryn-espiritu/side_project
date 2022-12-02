class Api::CityMunicipalitiesController < ApplicationController
  def index
    province = Province.find(params[:province_id])
    city = province.city_municipalities
    render json: city, each_serializer: CityMunicipalitySerializer
  end
end
