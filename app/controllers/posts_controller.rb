class PostsController < ApplicationController
  before_action :set_post, only: [:show]
  before_action :set_all_posts

  def index
    @groups = Post.group_by_year
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def show
    raise ActionController::RoutingError.new("無此文章") if not @post
  end

  def search
    
  end

  def render_markdown
    content = params[:post].join("\n")
    post = Post.new(:content => content)
    render json: {post: post.parse}
  end

  def overview
    @groups = Post.group_by_year
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
