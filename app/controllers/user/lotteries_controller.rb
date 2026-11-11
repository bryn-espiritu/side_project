class User::LotteriesController < ApplicationController
  before_action :authenticate_user!, only: [:show, :create]
  before_action :set_item, only: [:show]

  MAX_BETS_PER_REQUEST = 100

  def index
    @news_tickers = NewsTicker.active
    @banners = Banner.active
    @items = Item.starting.active
    @items = @items.includes(:categories).where(categories: { name: params[:categories] }) if params[:categories].present?
    @categories = Category.all
  end

  def create
    count = Integer(params.dig(:bet, :coin), exception: false)
    unless count && count.between?(1, MAX_BETS_PER_REQUEST)
      return redirect_to user_lotteries_path, alert: "Enter between 1 and #{MAX_BETS_PER_REQUEST} bets."
    end

    current_user.with_lock do
      item = Item.starting.active.find(params[:item_id])
      if current_user.coins < count
        raise ActiveRecord::RecordInvalid, current_user
      end

      count.times do
        Bet.create!(user: current_user, item: item, batch_count: item.batch_count, coin: 1)
      end
    end

    redirect_to user_lotteries_path, notice: "Bets placed successfully."
  rescue ActiveRecord::RecordInvalid
    redirect_to user_lotteries_path, alert: "Not enough coins or invalid bet."
  rescue ActiveRecord::RecordNotFound
    redirect_to user_lotteries_path, alert: "This lottery is not available."
  end

  def show
    @bet = Bet.new
    @bets = current_user.bets.where(item: @item, batch_count: @item.batch_count)
    @serial_number = @bets
  end

  private

  def set_item
    @item = Item.starting.active.find(params[:id])
  end
end
