class User::AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: [:edit, :update, :destroy]

  def index
    @many_address = current_user.addresses.includes(:user, :region, :province, :city_municipality, :barangay)
  end

  def new
    @address = current_user.addresses.build
  end

  def create
    @address = current_user.addresses.build(address_params)
    if @address.save
      redirect_to user_addresses_path, notice: "Address is Successfully Submitted"
    else
      flash.now[:alert] = @address.errors.full_messages.join(', ')
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @address.update(address_params)
      redirect_to user_addresses_path, notice: "Address successfully updated"
    else
      flash.now[:alert] = @address.errors.full_messages.join(', ')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @address.destroy
      redirect_to user_addresses_path, notice: "Address successfully deleted"
    else
      redirect_to user_addresses_path, alert: @address.errors.full_messages.join(', ')
    end
  end

  private

  def address_params
    params.require(:address).permit(:genre, :is_default, :name, :street_address, :phone_number,
                                    :region_id, :province_id, :city_municipality_id, :barangay_id, :remark)
  end

  def set_address
    @address = current_user.addresses.find(params[:id] || params[:address_id])
  end
end
