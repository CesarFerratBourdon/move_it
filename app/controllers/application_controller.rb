class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  #->Prelang (user_login:devise)
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation, :remember_me])
      devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :username, :email, :password, :remember_me])
      devise_parameter_sanitizer.permit(:account_update, keys:[:username, :email, :password, :password_confirmation, :current_password])
  end

    # def stored_location_for(resource)
    #   nil
    # end

  def after_sign_in_path_for(resource)
      dashboard_path
  end


end
