class Users::CategoriesController < ApplicationController
  before_action :require_admin

  def edit_all
    @categories = Category.all
  end
end
