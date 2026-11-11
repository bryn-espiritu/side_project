class User::ShareController < ApplicationController
  before_action :authenticate_user!
  before_action :set_winner, except: :index

  def index
    @news_tickers = NewsTicker.active
    @banners = Banner.active
    @winners = Winner.includes(:item, :user).published
  end

  def edit; end

  def update
    unless @winner.may_share?
      return redirect_to user_user_profile_path, alert: "This prize cannot be shared yet."
    end

    Winner.transaction do
      @winner.update!(winner_params)
      @winner.share!
    end
    redirect_to user_user_profile_path, notice: "Shared Successfully!"
  rescue ActiveRecord::RecordInvalid, AASM::InvalidTransition => e
    redirect_to user_user_profile_path, alert: e.message
  end

  private

  def set_winner
    @winner = current_user.winners.find(params[:id] || params[:winner_id])
  end

  def winner_params
    params.require(:winner).permit(:picture, :comments)
  end
end
