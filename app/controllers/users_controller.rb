class UsersController < ApplicationController
  layout "backend"
  before_action :require_login
  before_action :set_email, only: [:subscribe, :unsubscribe, :send_post_emails]
  before_action :email_formatted?, only: [:subscribe]
  before_action :email_already_in_list_and_subscribed?, only: [:subscribe]
  # require 'rest-client'
  require 'mailgun'

  def show
    @user = User.find_by_name(params[:name])
  end

  def subscribe
    if in_list?
      @mailgun.list_members(@list).update params[:email], {:subscribed => "yes"}
      flash[:notice] = "已恢復#{@email}的訂閱狀態"
    else
      @mailgun.list_members(@list).add(@email)
      flash[:notice] = "已將#{@email}加入名單"
    end
    redirect_to posts_path
  end

  def unsubscribe
    @mailgun.list_members(@list).update params[:email], {:subscribed => "no"}
    @mail = params[:email]
  end

  def send_post_email
    a = [
      {"address"=>"nkj20932@hotmail.com", "name"=>"", "subscribed"=>true, "vars"=>{}},
      {"address"=>"nkj20932@gmail.com", "name"=>"", "subscribed"=>true, "vars"=>{}}
    ]
    i = 0
    # @member_list.each do |object|
    a.each do |object|
      if object["subscribed"] == true
        SubscriptionMailer.subscription(
          object["address"], 
          Array.new(1,Post.find(params[:format]))
        ).deliver
        i += 1
      end
    end
    flash[:notice] = "已發送Email給 #{i} 位訂閱者：#{Post.find(params[:format]).title}"
    redirect_to posts_path
  end

  private
    def set_email
      @mailgun = Mailgun()
      @email = params[:email]
      @list = "service@mg.motion-express.com" 
      @member_list ||= @mailgun.list_members(@list).list 
    end

    def email_already_in_list_and_subscribed?
      address_list = @member_list.map{|m|m["address"]}
      if address_list.include?(@email)
        if already_subscribed?
          flash[:alert] = "email先前已訂閱"
          redirect_to posts_path
          return
        end
      end
    end

    def email_formatted?
      if not @email.include?("@")
        flash[:alert] = "請輸入正確的email格式"
        redirect_to posts_path
        return false
      end
      true
    end

    def in_list?
      @member_list.find{|item| item["address"] == @email}
    end

    def already_subscribed?
      @member_list.find{|item| item["address"] == @email}["subscribed"] == true
    end
end
