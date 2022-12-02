class Api::ProvincesController < ApplicationController
  def index
    region = Region.find(params[:region_id])
    province = region.provinces
    render json: province, each_serializer: ProvinceSerializer
  end
end
