class TrainingsController < ApplicationController
  def index
  end

  def show
    @training = Training.find_by_slug(params[:id])
    cat = Category.find(@training[:category_id])[:name]
    respond_to do |format|
      format.json {
        render :json => @training.serializable_hash.merge(:category => cat)
      }
    end
  end
end
