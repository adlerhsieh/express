class Users::TrainingsController < ApplicationController
  def index
    @trainings = Training.all
  end

  def new
    @training = Training.new
  end

  def edit
    @training = Training.find_by_slug(params[:id])
    @screen_casts = ScreenCast.all
  end

  def selections
    @training = Training.find_by_slug(params[:id])
    @screen_casts_selected = @training.screen_casts
    render :json => @screen_casts_selected
  end

  def not_selected
    @training = Training.find_by_slug(params[:id])
    @screen_casts = ScreenCast.all
    render :json => @screen_casts - @training.screen_casts
  end

  def create
    @training = Training.new(training_params)
    @training.content = params[:content].join("\n")
    if @training.save
      render json: {result: "success", slug: @training.slug}
    end
  end

  def update
    @training = Training.find_by_slug(params[:id])
    if @training.update!(training_params) && @training.update_attribute(:content, params[:content].join("\n"))
      render json: {result: "success", slug: @training.slug}
    end
  end

  def toggle_public
    @training = Training.find_by_slug(params[:id])
    if @training[:is_public]
      @training.update_column(:is_public, false)
    else
      @training.update_column(:is_public, true)
    end
    render json: {result: "success", is_public: @training[:is_public]}
  end

  private
    def training_params
      params.permit(:title, :video_embed, :image_embed, :slug, :display_date)
    end
end
