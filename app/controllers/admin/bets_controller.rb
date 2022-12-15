class Admin::BetsController < AdminController
  def index
    @bets = Bet.includes(:user, :item)
    @bets = @bets.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @bets = @bets.where(item: { name: params[:item.name] }) if params[:item.name].present?
    @bets = @bets.where(user: { email: params[:email] }) if params[:email].present?
    @bets = @bets.where(state: params[:state]) if params[:state].present?
    @bets = @bets.where('bets.created_at >= ?', params[:created_at]) if params[:created_at].present?
    @bets = @bets.where('bets.created_at <= ?', params[:ended_at]) if params[:ended_at].present?
  end

  def cancel
    @bet = Bet.find(params[:bet_id])
    if @bet.cancel!
      flash[:notice] = "Successfully Cancelled!"
    else
      flash[:alert] = @bet.errors.full_messages.join(', ')
    end
    redirect_to admin_bets_path
  end
end


