class User::UserProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @orders = current_user.orders.page(params[:page]) if params[:order] == "orders"
    @bets = current_user.bets.page(params[:page]) if params[:bet] == "bets"
    @winners = current_user.winners.page(params[:page]) if params[:winner] == "winners"
  end
end
