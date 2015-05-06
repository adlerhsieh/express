class Users::ScreenCastsController < ApplicationController
  def index
    @screen_casts = ScreenCast.all
  end

  def new
    @screen_cast = ScreenCast.new
  end

  def edit
  end

  def show
  end
end
