class ScreencastsController < ApplicationController
  def show
    #todo redirect routing from without training to with training if training_id
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
end
