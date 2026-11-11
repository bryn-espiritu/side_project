# frozen_string_literal: true

class Admins::SessionsController < Devise::SessionsController
  def create
    user = User.find_for_authentication(email: params.dig(:admin_user, :email))
    if user && !user.admin?
      redirect_to new_admin_user_session_path, alert: "You don't have permission"
    else
      super
    end
  end
end
