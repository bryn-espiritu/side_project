class User::UserProfilesController < ApplicationController

  def show
    @user = current_user
    @orders = Order.where(user: @user).page(params[:page]) if params[:order] == "orders"
    @bets = Bet.where(user: @user).page(params[:page]) if params[:bet] == "bets"
    @winners = Winner.where(user: @user).page(params[:page]) if params[:winner] == "winners"
  end

  private

  def winner_params
    params.require(:winner).permit(:address_id)
  end
end

