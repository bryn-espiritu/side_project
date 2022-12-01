class Api::ProvincesController < ApplicationController
  def index
    province = Province.all
    render json: province, each_serializer: ProvinceSerializer
  end
end
