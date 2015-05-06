class ScreenCastsController < ApplicationController
  def show
    @screen_cast = ScreenCast.find_by_slug(params[:id])
    respond_to do |format|
      format.json {
        render :json => @screen_cast
      }
    end
  end
end
