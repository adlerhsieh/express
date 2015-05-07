class ScreencastsController < ApplicationController
  def show
    return redirection_to_training if sceeencast_belongs_to_training
    @screencast = ScreenCast.find_by_slug(params[:id])
    cat = Category.find(@screencast[:category_id])[:name]
    if @screencast[:training_id]
      @training = Training.includes(:screen_casts).find(@screencast.training[:id])
      @screencasts = @training.screen_casts.order(:display_date => :asc)
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
      training = ScreenCast.find_by_slug(params[:id]).training
      redirect_to training_screencast_path(training[:slug], params[:id])
    end

    def sceeencast_belongs_to_training
      if not params[:training_id]
        if ScreenCast.find_by_slug(params[:id])[:training_id]
          return true
        end
      end
      false
    end
end
