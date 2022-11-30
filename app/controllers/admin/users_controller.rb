class Admin::UsersController < ApplicationController
<<<<<<< HEAD
  def index
    @users = User.all
  end
=======
  # before_action :authenticate_user!
  # before_action :check_admin

  def index
    @users = User.all
  end

  def check_admin
    raise ActionController::RoutingError.new("404 ERROR: Not Found") unless current_user.admin?
  end

  before_action :set_locale
  def set_locale
    if params[:locale] && I18n.available_locales.include?( params[:locale].to_sym )
      session[:locale] = params[:locale]
    end

    I18n.locale = session[:locale] || I18n.default_locale
  end
>>>>>>> 17ab207 ([Feature 1] add set_locale to admin::user_controller)
end
