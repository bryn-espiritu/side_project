class Admin::OrdersController < AdminController
  before_action :set_event, only: [:pay, :cancel]

  def index
    @orders = Order.includes(:user, :offer)
    @orders = @orders.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @orders = @orders.where(email: params[:email]) if params[:email].present?
    @orders = @orders.where(genre: params[:genre]) if params[:genre].present?
    @orders = @orders.where(state: params[:state]) if params[:state].present?
    @orders = @orders.where(offer: params[:offer]) if params[:offer].present?
    @orders = @orders.where('orders.created_at >= ?', params[:created_at]) if params[:created_at].present?
    @orders = @orders.where('orders.ended_at <= ?', params[:ended_at]) if params[:ended_at].present?
    @total_amount = Order.sum(:amount)
    @total_coin = Order.sum(:coin)
    @sub_total_amount = @orders.sum(:amount)
    @sub_total_coin = @orders.sum(:coin)

  end

  def pay
    if @order.pay!
      flash[:notice] = "Paid Successfully!"
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
    end
    redirect_to admin_orders_path
  end

  def cancel
    if @order.cancel!
      flash[:notice] = "Successfully Cancelled!"
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
    end
    redirect_to admin_orders_path

  end

  private

  def set_event
    @order = Order.find(params[:order_id])
  end
end