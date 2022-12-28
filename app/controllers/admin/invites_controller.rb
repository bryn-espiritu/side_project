class Admin::InvitesController < AdminController

  def index
    @users = User.where.not(parent: nil)
    @users = @users.where(email: params[:parent]) if params[:parent].present?

  end

end
