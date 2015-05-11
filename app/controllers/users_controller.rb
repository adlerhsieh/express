class UsersController < ApplicationController
  layout "backend"
  before_action :require_login

  def show
    @user = User.find_by_name(params[:name])
  end
end
