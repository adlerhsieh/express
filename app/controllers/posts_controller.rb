class PostsController < ApplicationController
  before_action :set_post, only: [:show]
  before_action :set_all_posts
  before_action :require_admin, only: [:create, :update]

  def index
    set_all_public_posts
  end

  def show
    raise ActionController::RoutingError.new("無此文章") if not @post
    respond_to do |format|
      format.html
      format.json {
        render :json => {
          post: @post,
          category: @post.category,
          tags: @post.tags.map(&:name).join(", ")
        }
      }
    end
  end

  def create
    @post = Post.new(post_params)
    set_post_params
    if @post.save
      create_tags
      render json: {result: "success", slug: @post.slug}
    end
  end

  def update
    @post = Post.find_by_slug(params[:slug])
    set_post_params
    if @post.save
      refresh_tags
      toggle_public if params[:toggle_public]
      render json: {result: "success", is_public: @post[:is_public]}
    end
  end

  def render_markdown
    content = params[:post].join("\n")
    post = Post.new(:content => content)
    render json: {post: post.parse}
  end

  def search
    @posts = Post.where("title LIKE ? OR content like ?", "%#{params[:search]}%", "%#{params[:search]}%")
  end

  def author
  end

  private
    def toggle_public
      if @post[:is_public]
        @post.update_column(:is_public, false)
      else
        @post.update_column(:is_public, true)
      end
    end

    def set_all_public_posts
      @posts = Post.where(:is_public => true).order(:display_date => :desc)
      @categories = Category.all
    end

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

    def set_post_params
      @category = Category.create_with(slug: params[:category]).find_or_create_by(name: params[:category]) unless params[:category].nil?
      @post.title = params[:title]
      @post.category_id = @category[:id]
      @post.content = params[:content].join("\n")
      @post.display_date = params[:display_date]
    end

    def refresh_tags
      PostTag.where(:post_id => @post[:id]).each {|tag| tag.delete }
      create_tags
    end

    def create_tags
      if params[:tags]
        tags = params[:tags].gsub(" ","").split(",")
        tags.each do |tag|
          query_tag = Tag.create_with(slug: tag).find_or_create_by(name: tag)
          PostTag.create(post_id: @post.id, tag_id: query_tag.id)
        end
      end
    end
end
