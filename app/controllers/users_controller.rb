class UsersController < ApplicationController
  layout "backend"
  before_action :require_login
  # require 'rest-client'

  def show
    @user = User.find_by_name(params[:name])
  end

  def subscribe
    email = params[:email]
    @mailgun = Mailgun()
    # puts @mailgun.list_members("service@mg.motion-express.com").list
    redirect_to posts_path
  end
end
