class PostsController < ApplicationController
  before_action :set_post, :only => [:show]

  def index
  end

  def new
  end

  def edit
  end

  def show
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end
end
