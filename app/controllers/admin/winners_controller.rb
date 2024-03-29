class Admin::WinnersController < AdminController
  before_action :set_winner, except: :index

  def index
    @winners = Winner.includes(:user, :item, :bet, :address)
    @winners = @winners.where(bet: { serial_number: params[:serial_number] }) if params[:serial_number].present?
    @winners = @winners.where(user: { email: params[:email] }) if params[:email].present?
    @winners = @winners.where(item: { name: params[:product_name] }) if params[:product_name].present?
    @winners = @winners.where(state: params[:state]) if params[:state].present?
    @winners = @winners.where('winners.created_at >= ?', params[:created_at]) if params[:created_at].present?
    @winners = @winners.where('winners.created_at <= ?', params[:ended_at]) if params[:ended_at].present?
  end

  def submit
    if @winner.may_submit?
      @winner.submit!
      flash[:notice] = "Successfully Submitted!"
    else
      flash[:alert] = @winner.errors.full_messages.join(', ')
    end
    redirect_to admin_winners_path
  end

  def pay
    if @winner.may_pay?
      @winner.pay!
      flash[:notice] = "Successfully Paid!"
    else
      flash[:alert] = @winner.errors.full_messages.join(', ')
    end
    redirect_to admin_winners_path
  end

  def ship
    if @winner.may_ship?
      @winner.ship!
      flash[:notice] = "Successfully Shipped!"
    else
      flash[:alert] = @winner.errors.full_messages.join(', ')
    end
    redirect_to admin_winners_path
  end

  def deliver
    if @winner.may_deliver?
      @winner.deliver!
      flash[:notice] = "Successfully Delivered!"
    else
      flash[:alert] = @winner.errors.full_messages.join(', ')
    end
    redirect_to admin_winners_path
  end

  def publish
    if @winner.may_publish?
      @winner.publish!
      flash[:notice] = "Successfully Published!"
    else
      flash[:alert] = @winner.errors.full_messages.join(', ')
    end
    redirect_to admin_winners_path
  end

  def remove_publish
    if @winner.may_remove_publish?
      @winner.remove_publish!
      flash[:notice] = "Successfully Remove Published!"
    else
      flash[:alert] = @winner.errors.full_messages.join(', ')
    end
    redirect_to admin_winners_path
  end

  private

  def set_winner
    @winner = Winner.find(params[:id] || params[:winner_id])
  end
end
