class PostsController < ApplicationController
  before_action :set_post

  def index
  end

  def new
  end

  def edit
  end

  def show
    if not @post
      raise ActionController::RoutingError.new("無此文章")
    end
  end

  private
    def set_post
      @posts = Post.all
      @post = Post.find_by_slug(params[:slug])
      @categories = Category.all
    end
end
