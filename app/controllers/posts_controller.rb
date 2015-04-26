class PostsController < ApplicationController
  before_action :set_post, only: [:show]
  before_action :set_all_posts

  def index
    @groups = Post.group_by_year
  end

  def new
  end

  def edit
  end

  def show
    raise ActionController::RoutingError.new("無此文章") if not @post
  end

  private
    def set_all_posts
      @posts = Post.all.order(:display_date => :desc)
      @categories = Category.all
    end

    def set_post
      @post = Post.find_by_slug(params[:slug])
    end
end
