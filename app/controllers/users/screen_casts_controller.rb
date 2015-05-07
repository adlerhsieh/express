class Users::ScreenCastsController < ApplicationController
  def index
    @screen_casts = ScreenCast.all
    respond_to do |format|
      format.html
      format.json { render json: @screen_casts }
    end
  end

  def new
    @screen_cast = ScreenCast.new
  end

  def edit
    @screen_cast = ScreenCast.find_by_slug(params[:id])
  end

  def create
    @screen_cast = ScreenCast.new(screen_cast_params)
    category = Category.create_with(slug: params[:category]).find_or_create_by(name: params[:category]) unless params[:category].nil?
    @screen_cast.category_id = category[:id]
    @screen_cast.content = params[:content].join("\n")
    if @screen_cast.save
      render json: {result: "success", slug: @screen_cast.slug}
    end
  end

  def update
    @screen_cast = ScreenCast.find_by_slug(params[:id])
    category = Category.create_with(slug: params[:category]).find_or_create_by(name: params[:category]) unless params[:category].nil?
    @screen_cast.category_id = category[:id]
    if @screen_cast.update!(screen_cast_params) && @screen_cast.update_attribute(:content, params[:content].join("\n"))
      render json: {result: "success", slug: @screen_cast.slug}
    end
  end

  def toggle_public
    @screen_cast = ScreenCast.find_by_slug(params[:id])
    if @screen_cast[:is_public]
      @screen_cast.update_column(:is_public, false)
    else
      @screen_cast.update_column(:is_public, true)
    end
    render json: {result: "success", is_public: @screen_cast[:is_public]}
  end

  def destroy
    @screen_cast = ScreenCast.find_by_slug(params[:id])
    @screen_cast.delete
    redirect_to user_screen_casts_path(current_user["name"])
  end

  private
    def screen_cast_params
      params.permit(:title, :video_embed, :image_embed, :slug, :display_date)
    end
end
