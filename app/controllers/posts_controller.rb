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

  def create
    @post = Post.new(post_params)
    @category = Category.create_with(slug: params[:category]).find_or_create_by(name: params[:category]) unless params[:category].nil?
    @post.category_id = @category[:id]
    @post.content = params[:content].join("\n")
    @post.display_date = Date.today
    if @post.save
      if params[:tags]
        tags = params[:tags].split(",")
        tags.each do |tag|
          query_tag = Tag.create_with(slug: tag).find_or_create_by(name: tag)
          PostTag.create(post_id: @post.id, tag_id: query_tag.id)
        end
      end
      render json: {result: "success"}
    else
      render json: {result: "error"}
    end
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

    def post_params
      params.permit(:title, :slug)
    end
end
