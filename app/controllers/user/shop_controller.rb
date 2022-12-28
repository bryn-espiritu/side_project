class User::ShopController < ApplicationController
  before_action :authenticate_user!

  def index
    @offers = Offer.active
    @offer = Offer.new
  end

  def create
    @order = Order.new
    @offer = Offer.find(params[:id])
    @order.offer = @offer
    @order.amount = @offer.amount
    @order.coin = @offer.coin
    @order.user = current_user
    @order.state = :submitted
    @order.genre = 0
    if @order.save
      redirect_to user_shop_index_path, notice: "Order has been Successfully Submitted "
    else
      redirect_to user_shop_index_path, notice: @order.errors
    end
  end
end
