class User::AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: [:edit, :update, :destroy]


  def index
    @many_address = current_user.addresses.includes(:user, :region, :province, :city_municipality, :barangay)
  end

  def new
    @address = Address.new

  end

  def create
    @address = Address.new(address_params)
    @address.user = current_user
    if @address.save
      redirect_to user_addresses_path, notice: "Address is Successfully Submitted"
    else
      flash[:alert] = @address.errors.full_messages.join(', ')
      render :new
    end
  end

  def edit;
  end

  def update
    if @address.update(address_params)
      redirect_to user_addresses_path
    end
  end

  def destroy
    if @address.destroy
      redirect_to user_addresses_path, notice: "Address successfully deleted"
    end
  end

  private

  def address_params
    params.require(:address).permit(:genre, :is_default, :name, :street_address, :phone_number,
                                    :region_id, :province_id, :city_municipality_id, :barangay_id, :remark)
  end

  def set_address
    @address = Address.find(params[:id] || params[:address_id])
  end


end
