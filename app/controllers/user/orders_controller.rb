class User::OrdersController < ApplicationController
  before_action :set_event, only: [:pay, :cancel]

  def index
    @orders = Order.includes(:user, :offer)

  end

  def cancel
    if @order.cancel!
      flash[:notice] = "Successfully Cancelled!"
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
    end
    redirect_to user_user_profile_path
  end

  private

  def set_event
    @order = Order.find(params[:order_id])
  end
end

