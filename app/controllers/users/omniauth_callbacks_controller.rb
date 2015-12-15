class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @auth = request.env["omniauth.auth"]
    user = User.find_by_omniauth(@auth)
    if not user
      user = User.create!(auth_params)
    end
    if current_order
      if not current_order.user
        current_order.user = user
      end
    end
    sign_in_and_redirect user, :event => :authentication
    set_flash_message(:notice, :success, :kind => "Github") if is_navigational_format?
  end

  private

  def auth_params
    token = Devise.friendly_token[0,20]
    {
      email: @auth.info.email,
      password: token,
      password_confirmation: token,
      name: @auth.info.name,
      provider: @auth.provider,
      uid: @auth.uid
    }
  end
end
