class Users::PostsController < ApplicationController
  before_action :require_admin, only: [:create, :update]

  def index
    @posts = Post.order(:display_date => :desc)
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find_by_slug(params[:id])
  end
end
