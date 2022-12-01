class Api::BarangaysController < ApplicationController
  def index
    brgy = Barangay.all
    render json: brgy, each_serializer: BarangaySerializer
  end
end
