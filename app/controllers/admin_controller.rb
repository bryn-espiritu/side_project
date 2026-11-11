class AdminController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :require_admin!
  before_action :set_locale

  private

  def require_admin!
    head :forbidden unless current_admin_user&.admin?
  end

  def set_locale
    requested_locale = params[:locale]&.to_sym
    session[:locale] = requested_locale if I18n.available_locales.include?(requested_locale)
    I18n.locale = session[:locale] || I18n.default_locale
  end
end
