class UsersController < ApplicationController
  def show
    @user = User.find_by_name(params[:name])
    @posts = Post.order(:display_date => :desc)
  end
end
