class User::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:cancel]

  def index
    @orders = current_user.orders.includes(:offer)
  end

  def cancel
    if @order.may_cancel?
      @order.cancel!
      redirect_to user_user_profile_path, notice: "Successfully Cancelled!"
    else
      redirect_to user_user_profile_path, alert: "This order cannot be cancelled."
    end
  end

  private

  def set_event
    @order = current_user.orders.find(params[:order_id] || params[:id])
  end
end
