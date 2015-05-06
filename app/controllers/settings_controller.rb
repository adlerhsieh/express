class SettingsController < ApplicationController
  def index
    @settings = Setting.all
  end

  def update_all
    
  end
end
