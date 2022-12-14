class Admin::BetsController < AdminController
  def index
    @bets = Bet.includes(:user, :item)
    @bets = @bets.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @bets = @bets.where(item: {name: params[:item.name]}) if params[:item.name].present?
    @bets = @bets.where(user: {email: params[:email]}) if params[:email].present?
    @bets = @bets.where(state: params[:state]) if params[:state].present?
  end
end
