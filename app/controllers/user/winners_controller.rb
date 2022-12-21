class User::WinnersController < ApplicationController
  before_action :set_winner, only: [:edit, :update]

  def edit; end

  def update
    if @winner.update(winner_params)
      @winner.claim!
      redirect_to user_user_profile_path
      flash[:notice] = "Successfully claimed!"
    else
      flash[:alert] = @winner.errors.full_messages.join(', ')
      redirect_to user_user_profile_path
    end
    # render json: params
  end

  private

  def set_winner
    @winner = Winner.find(params[:id] || params[:winner_id])
  end

  def winner_params
    params.require(:winner).permit(:address_id)
  end
end
