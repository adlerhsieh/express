class Users::TrainingsController < ApplicationController
  before_action :require_admin
  def index
    @trainings = Training.all
  end

  def new
    @training = Training.new
  end

  def edit
    @training = Training.find_by_slug(params[:id])
    @screencasts = Screencast.all
  end

  def selections
    @training = Training.find_by_slug(params[:id])
    @screencasts_selected = @training.screencasts.order(:training_order => :asc)
    render :json => @screencasts_selected
  end

  def not_selected
    @training = Training.find_by_slug(params[:id])
    screencasts = Screencast.all - @training.screencasts
    result = screencasts.map do |s|
      training = s.training
      if s[:training_id]
        s = s.serializable_hash
        s["training_title"] = training.title
        s["training_slug"] = training.slug
      end
      s
    end
    render :json => result
  end

  def update_selections
    @training = Training.find_by_slug(params[:id])
    Screencast.where(:training_id => @training[:id]).each do |s| 
      s.update_column(:training_id, nil)
      s.update_column(:training_order, nil)
    end
    if params[:selected]
      params[:selected].each do |s|
        screencast = Screencast.find(s[:id])
        screencast.update_column(:training_id, @training[:id])
        screencast.update_column(:training_order, s[:training_order])
      end
    end
    render json: { updated: "success" }
  end

  def create
    @training = Training.new(training_params)
    @training.content = params[:content].join("\n")
    category = Category.create_with(slug: params[:category]).find_or_create_by(name: params[:category]) unless params[:category].nil?
    @training.category_id = category[:id]
    if @training.save
      render json: {result: "success", slug: @training.slug}
    end
  end

  def update
    @training = Training.find_by_slug(params[:id])
    category = Category.create_with(slug: params[:category]).find_or_create_by(name: params[:category]) unless params[:category].nil?
    @training.category_id = category[:id]
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

  def destroy
    @training = Training.find_by_slug(params[:id])
    id = @training[:id]
    Screencast.where(:training_id => id).each do |s|
      s.update_column(:training_id, nil)
    end
    @training.delete
    redirect_to user_trainings_path(current_user["name"])
  end

  private
    def training_params
      params.permit(:title, :video_embed, :image_embed, :slug, :display_date, :skip)
    end
end
