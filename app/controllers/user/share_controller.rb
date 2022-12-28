class User::ShareController < ApplicationController
  before_action :authenticate_user!
  before_action :set_winner, except: :index

  def index
    @news_tickers = NewsTicker.active
    @banners = Banner.active
    @winners = Winner.includes(:item, :user).published
  end
  
  def edit;
  end

  def update;
    if @winner.update(winner_params)
      @winner.share!
      redirect_to user_user_profile_path
      flash[:notice] = "Shared Successfully!"
    else
      flash[:alert] = @winner.errors.full_messages.join(', ')
      redirect_to user_user_profile_path
    end
  end

  private

  def set_winner
    @winner = Winner.find(params[:id] || params[:winner_id])
  end

  def winner_params
    params.require(:winner).permit(:picture, :comments)
  end
end
