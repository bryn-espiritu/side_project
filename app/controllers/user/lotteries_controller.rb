class User::LotteriesController < ApplicationController
  before_action :set_item, only: [:show]

  def index
    @news_tickers = NewsTicker.active
    @banners = Banner.active
    @items = Item.starting.active
    @items = @items.includes(:categories).where(categories: { name: params[:categories] }) if params[:categories]
    @categories = Category.all
  end

  def create
    @may_bet = params[:bet][:coin].to_i
    params[:bet][:coin] = 1
    @may_bet.times {
      @bet = Bet.new(bet_params)
      @bet.user = current_user
      @bet.item_id = params[:item_id]
      @bet.batch_count = @bet.item.batch_count
      @bet.save
    }
    redirect_to user_lotteries_path
  end

  def show
    @bet = Bet.new
    @bets = Bet.includes(:item, :user).all
    @serial_number = @bets.where(user: current_user, batch_count: @item.batch_count, item: @item)
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def bet_params
    params.require(:bet).permit(:coin, :user_id, :item_id, :serial_number)
  end
end
