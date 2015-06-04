class UsersController < ApplicationController
  layout "backend"
  before_action :require_login, except: [:unsubscribe, :subscribe]
  before_action :set_email, only: [:subscribe, :unsubscribe, :send_post_email]
  before_action :email_formatted?, only: [:subscribe]
  before_action :email_already_in_list_and_subscribed?, only: [:subscribe]
  # require 'rest-client'
  require 'mailgun'

  def show
    @user = User.find_by_name(params[:name])
  end

  def balance
    render :json => {
      :balance => translator_balance,
      :usage => translator_usage
    }
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
    # a = [
      # {"address"=>"nkj20932@hotmail.com", "name"=>"", "subscribed"=>true, "vars"=>{}},
      # {"address"=>"nkj20932@gmail.com", "name"=>"", "subscribed"=>true, "vars"=>{}}
      # {"address"=>"nkj20932@ymail.com", "name"=>"", "subscribed"=>true, "vars"=>{}}
    # ]
    i = 0
    posts = []
    if params[:array]
      params[:array].each { |id| posts << Post.find(id) }
    else
      render json: "failed"
      return
    end
    @member_list.each do |object|
    # a.each do |object|
      if object["subscribed"] == true
        SubscriptionMailer.subscription(
          object["address"], 
          # Array.new(1,post)
          posts
        ).deliver_now
        i += 1
      end
    end
    flash[:notice] = "已發送Email給 #{i} 位訂閱者"
    posts.each {|post| post.update_column(:sent, Date.today) if i > 0 }
    redirect_to user_posts_path(current_user[:name])
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

    def translator_balance
      t = BingTranslator.new("motionexpress","XElPnc0gckRHGyAgi7Y6wV8nxiLU4GDPDUivxrfRoYo=", false, 'FPiShpptVGkvVNAIGXoV//zHZMtvIAgsG/PiVSztHb8')
      t.balance
      # "暫不顯示"
    end

    def translator_usage
      days = Time.days_in_month(Time.now.month, Time.now.year)
      max = (2000000 - translator_balance).to_f
      (max / days).round(2)
    end

end
