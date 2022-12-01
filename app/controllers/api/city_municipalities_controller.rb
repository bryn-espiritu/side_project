class Api::CityMunicipalitiesController < ApplicationController
  def index
    city = CityMunicipality.all
    render json: city, each_serializer: CityMunicipalitySerializer
  end
end
