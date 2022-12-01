class Api::RegionsController < ApplicationController
  def index
    regions = Region.all
    render json: regions, each_serializer: RegionSerializer
  end
end
