class User::WinnersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_winner, only: [:edit, :update]

  def edit; end

  def update
    unless @winner.may_claim?
      return redirect_to user_user_profile_path, alert: "This prize cannot be claimed."
    end

    address = current_user.addresses.find_by(id: winner_params[:address_id])
    return redirect_to(user_user_profile_path, alert: "Select one of your addresses.") unless address

    Winner.transaction do
      @winner.update!(address: address)
      @winner.claim!
    end
    redirect_to user_user_profile_path, notice: "Successfully claimed!"
  rescue ActiveRecord::RecordInvalid, AASM::InvalidTransition => e
    redirect_to user_user_profile_path, alert: e.message
  end

  private

  def set_winner
    @winner = current_user.winners.find(params[:id] || params[:winner_id])
  end

  def winner_params
    params.require(:winner).permit(:address_id)
  end
end
