class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @auth = request.env["omniauth.auth"]
    user = User.find_by_omniauth(@auth)
    if not user
      user = User.create!(auth_params)
    end
    # if user.persisted?
    sign_in_and_redirect user, :event => :authentication
    set_flash_message(:notice, :success, :kind => "Github") if is_navigational_format?
    # else
      # session["devise.github_data"] = request.env["omniauth.auth"]
      # flash[:alert] = "登入失敗"
      # redirect_to posts_path
    # end
  end

  private

  def auth_params
    token = Devise.friendly_token[0,20]
    {
      email: @auth.info.email,
      # encrypted_password: token,
      password: token,
      # password_confirmation: token,
      password_confirmation: token,
      name: @auth.info.name,
      provider: @auth.provider,
      uid: @auth.uid
    }
  end
end
