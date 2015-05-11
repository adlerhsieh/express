class Users::CategoriesController < ApplicationController
  layout "backend"
  before_action :require_admin

  def edit_all
    @categories = Category.all
  end
end
