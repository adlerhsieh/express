class ScreenCastsController < ApplicationController
  def show
    @screen_cast = ScreenCast.find_by_slug(params[:id])
    cat = Category.find(@screen_cast[:category_id])[:name]
    respond_to do |format|
      format.html
      format.json {
        render :json => @screen_cast.serializable_hash.merge(:category => cat)
      }
    end
  end
end
