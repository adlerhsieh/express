class TrainingsController < ApplicationController
  def index
  end

  def show
    @training = Training.find_by_slug(params[:id])
    respond_to do |format|
      format.json {
        render :json => @training
      }
    end
  end
end
