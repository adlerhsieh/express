class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_devise_params, if: :devise_controller?
  before_filter :load_settings
  def configure_devise_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation)
    end
  end

  def require_login
    redirect_to posts_path unless current_user
  end

  def require_admin
    if current_user
      if current_user.is_admin?
        return
      end
    end
    redirect_to sign_in_path 
  end

  def load_settings
    @settings = Setting.all.map(&:serializable_hash)
  end

end
