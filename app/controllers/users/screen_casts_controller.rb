class Users::ScreenCastsController < ApplicationController
  def index
    @screen_casts = ScreenCast.all
  end

  def new
    @screen_cast = ScreenCast.new
  end

  def edit
    @screen_cast = ScreenCast.find_by_slug(params[:id])
  end

  def create
    @screen_cast = ScreenCast.new(screen_cast_params)
    @screen_cast.content = params[:content].join("\n")
    if @screen_cast.save
      render json: {result: "success", slug: @screen_cast.slug}
    end
  end

  def update
    @screen_cast = ScreenCast.find_by_slug(params[:id])
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

  private
    def screen_cast_params
      params.permit(:title, :video_embed, :image_embed, :slug, :display_date)
    end
end
