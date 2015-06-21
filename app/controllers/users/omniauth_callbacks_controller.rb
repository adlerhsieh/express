class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      if current_order && current_order.user_id.nil?
        current_order.update_column(:user_id, current_user.id)
      end
      set_flash_message(:notice, :success, :kind => "Github") if is_navigational_format?
    else
      # session["devise.github_data"] = request.env["omniauth.auth"]
      flash[:alert] = "登入失敗"
      redirect_to posts_path
    end
  end
end
