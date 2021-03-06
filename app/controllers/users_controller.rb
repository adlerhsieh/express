class UsersController < ApplicationController
  layout "backend"
  before_action :require_login, except: [:unsubscribe, :subscribe, :require_sign_in]
  before_action :set_email, only: [:subscribe, :unsubscribe, :send_post_email]
  before_action :email_formatted?, only: [:subscribe]
  before_action :email_already_in_list_and_subscribed?, only: [:subscribe]

  def show
  end

  def require_sign_in
  end

  def info
    render(:json => "尚未登入") unless current_user
    @user = User.find_by_name(params[:id])
  end

  def balance
    render :json => {
      :balance => translator_balance,
      :usage => translator_usage
    }
  end

  def subscribe
    if in_list?
      flash[:notice] = "已恢復#{@email}的訂閱狀態"
    else
      User::Email.create!(blog_subscription: true, address: @email)
      flash[:notice] = "已將#{@email}加入名單"
    end
    redirect_to posts_path
  end

  def unsubscribe
    address = User::Email.find_by_address(@mail)
    address.update_column(:blog_subscription, false) if address
  end

  def send_post_email
    if not current_user.is_admin
      render json: "Authorization failed"
      return
    end
    posts = []
    if params[:array]
      params[:array].each { |id| posts << Post.find(id) }
    else
      render json: "No posts are selected"
      return
    end
    emails = User::Email.where(:blog_subscription => true).map(&:address)
    SubscriptionMailer.subscription(emails, posts).deliver_now if emails.length > 0
    posts.each {|post| post.update_column(:sent, Date.today)}
    render json: "已發送Email給 #{emails.length} 位訂閱者"
  end

  private
    def set_email
      @email = params[:email]
    end

    def email_already_in_list_and_subscribed?
      address_list = User::Email.all.map(&:address)
      if address_list.include?(@email)
        if already_subscribed?
          flash[:alert] = "You are already in the subscription list"
          redirect_to posts_path
          return
        end
      end
    end

    def email_formatted?
      if not @email.include?("@")
        flash[:alert] = "Please enter correct email format"
        redirect_to posts_path
        return false
      end
      true
    end

    def in_list?
      User::Email.find_by_address(@email)
    end

    def already_subscribed?
      User::Email.where(:blog_subscription => true, :address => @email).any?
    end

end
