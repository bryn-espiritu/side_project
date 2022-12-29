class AdminController < ActionController::Base
  before_action :set_locale

  def set_locale
    if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]
    end

    I18n.locale = session[:locale] || I18n.default_locale
  end

  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource) if is_navigational_format?
  end
end