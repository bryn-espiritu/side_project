# frozen_string_literal: true
class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
    unless cookies[:promoter]
      cookies[:promoter] = params[:promoter]
    end
  end

  # POST /resource
  def create
    super
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    #super
    parameter = params[:user]
    if parameter[:current_password].present? || parameter[:password_confirmation].present? || parameter[:password].present?
      update_profile_with_pass
    else
      update_profile
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def with_password
    params.require(:user).permit(:username, :phone, :image, :current_password, :password_confirmation, :password, :parent_id)
  end

  def without_password
    params.require(:user).permit(:username, :phone, :image, :parent_id)
  end

  def update_profile
    if params[:user][:current_password].blank?
      resource.update_without_password(without_password.except(:current_password))
      redirect_to user_user_profile_path
    else
      render :edit
    end
  end

  def update_profile_with_pass
    if resource.update_with_password(with_password)
      redirect_to new_user_session_path
    else
      render :edit
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  #

end
