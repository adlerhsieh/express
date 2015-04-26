class PostsController < ApplicationController
  before_action :set_post, only: [:show]
  before_action :set_all_posts

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
    def set_all_posts
      @posts = Post.all
      @categories = Category.all
    end

    def set_post
      @post = Post.find_by_slug(params[:slug])
    end
end
