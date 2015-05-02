class UsersController < ApplicationController
  def show
    @user = User.find_by_name(params[:name])
  end

  def edit_posts
    @posts = Post.order(:display_date => :desc)
  end
end
