class Users::ScreencastsController < ApplicationController
  layout "backend"
  before_action :require_admin

  def index
    @screencasts = Screencast.all.order(id: :desc)
    respond_to do |format|
      format.html
      format.json { render json: @screencasts }
    end
  end

  def new
    @screencast = Screencast.new
  end

  def show
    @screencast = Screencast.find_by_slug(params[:id])
    cat = Category.find(@screencast[:category_id])[:name]
    render :json => @screencast.serializable_hash.merge(:category => cat)
  end

  def edit
    @screencast = Screencast.find_by_slug(params[:id])
  end

  def create
    @screencast = Screencast.new(screencast_params)
    if params[:category].nil? || params[:category] == ""
      category = Category.default_category
    else
      category = Category.create_with(slug: params[:category]).find_or_create_by(name: params[:category])
    end
    @screencast.category_id = category[:id]
    @screencast.content = params[:content].join("\n")
    if @screencast.save
      render json: {result: "success", slug: @screencast.slug}
    end
  end

  def update
    @screencast = Screencast.find_by_slug(params[:id])
    if params[:category].nil? || params[:category] == ""
      category = Category.default_category
    else
      category = Category.create_with(slug: params[:category]).find_or_create_by(name: params[:category])
    end
    @screencast.category_id = category[:id]
    if @screencast.update!(screencast_params) && @screencast.update_attribute(:content, params[:content].join("\n"))
      render json: {result: "success", slug: @screencast.slug}
    end
  end

  def toggle_public
    @screencast = Screencast.find_by_slug(params[:id])
    if @screencast[:is_public]
      @screencast.update_column(:is_public, false)
    else
      @screencast.update_column(:is_public, true)
    end
    render json: {result: "success", is_public: @screencast[:is_public]}
  end

  def destroy
    @screencast = Screencast.find_by_slug(params[:id])
    @screencast.delete
    redirect_to user_screencasts_path(current_user["name"])
  end

  private
    def screencast_params
      params.permit(:title, :video_embed, :image_embed, :slug, :display_date, :icon)
    end
end
