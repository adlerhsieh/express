class UsersController < ApplicationController
  before_action :require_login

  def show
    @user = User.find_by_name(params[:name])
  end

  def posts
    @posts = Post.order(:display_date => :desc)
  end

  def categories
    @categories = Category.all
  end

  private
    def require_login
      redirect_to posts_path unless current_user
    end

end
