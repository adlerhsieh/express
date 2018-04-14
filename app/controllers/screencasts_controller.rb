class ScreencastsController < ApplicationController

  def index
    @screencasts = Screencast.independent.is_public.page(params[:page])
  end

  def show
    return redirection_to_training if sceeencast_belongs_to_training
    @screencast = Screencast.find_by_slug(params[:id])
    cat = Category.find(@screencast[:category_id])[:name]
    if @screencast[:training_id]
      @training = Training.includes(:screencasts).find(@screencast.training[:id])
      @screencasts = @training.screencasts.order(:training_order => :asc)
    end
    respond_to do |format|
      format.html
      format.json {
        render :json => @screencast.serializable_hash.merge(:category => cat)
      }
    end
  end

  private
    def redirection_to_training
      training = Screencast.find_by_slug(params[:id]).training
      redirect_to training_screencast_path(training[:slug], params[:id])
    end

    def sceeencast_belongs_to_training
      if not params[:training_id]
        if Screencast.find_by_slug(params[:id])[:training_id]
          return true
        end
      end
      false
    end
end
