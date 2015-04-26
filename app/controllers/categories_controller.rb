class CategoriesController < ApplicationController
  def show
    @category = Category.find_by_name(params[:name])
  end
end
