class Admin::UsersController < ApplicationController
<<<<<<< HEAD
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
=======
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @users = User.all
  end
>>>>>>> 4f9f907 ([Feature 2] adding domain config | adding constraint)

  def check_admin
    raise ActionController::RoutingError.new("404 ERROR: Not Found") unless current_user.admin?
  end
<<<<<<< HEAD

  before_action :set_locale
  def set_locale
    if params[:locale] && I18n.available_locales.include?( params[:locale].to_sym )
      session[:locale] = params[:locale]
    end

    I18n.locale = session[:locale] || I18n.default_locale
  end
>>>>>>> 17ab207 ([Feature 1] add set_locale to admin::user_controller)
=======
>>>>>>> 4f9f907 ([Feature 2] adding domain config | adding constraint)
end
