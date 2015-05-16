class UsersController < ApplicationController
  layout "backend"
  before_action :require_login, :setup
  before_action :set_email, only: [:subscribe]
  # require 'rest-client'

  def show
    @user = User.find_by_name(params[:name])
  end

  def subscribe
    if email_formatted? && email_valid?
      list = "service@mg.motion-express.com" 
      @mailgun.list_members(list).add(@email)
      flash[:notice] = "已將#{email}加入名單"
      redirect_to posts_path
    end
  end

  private
    def setup
      @mailgun = Mailgun()
    end

    def set_email
      @email = params[:email]
    end

    def email_valid?
      list = @mailgun.list_members("service@mg.motion-express.com").list.map{|m|m["address"]}
      if list.include? @email
        flash[:alert] = "email已經存在於名單內"
        redirect_to posts_path
        return false
      end
      true
    end

    def email_formatted?
      if not @email.include?("@")
        flash[:alert] = "請輸入正確的email格式"
        redirect_to posts_path
        return false
      end
      true
    end
end
