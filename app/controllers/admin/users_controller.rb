class Admin::UsersController < AdminController
  before_action :set_balance_operate, only: [:create, :new]

  def index
    @users = User.includes(:orders).all
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.user = @user
    @order.genre = params[:genre]
    if @order.save
      if @order.submit! && @order.may_pay? && @order.pay!
        redirect_to admin_user_new_path, notice: "Order Successfully saved"
      else
        @order.cancel!
        flash[:alert] = @order.errors.full_messages.join(', ')
        redirect_to admin_user_new_path, alert: "Error: Invalid Amount"
      end
    else
      redirect_to admin_users_path, alert: "Error"
    end
  end

  private

  def set_balance_operate
    @user = User.find(params[:user_id] || params[:id])
  end

  def order_params
    params.require(:order).permit(:coin, :remarks)
  end
end
