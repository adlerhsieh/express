class Users::PostsController < ApplicationController
  layout "backend"
  before_action :require_admin

  def index
    @posts = Post.order(:display_date => :desc)
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find_by_slug(params[:id])
  end
  
  def destroy
    @post = Post.find_by_slug(params[:id])
    @post.delete
    redirect_to user_posts_path(current_user["name"])
  end

end
