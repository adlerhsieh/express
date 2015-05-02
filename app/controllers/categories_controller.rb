class CategoriesController < ApplicationController
  def show
    @category = Category.find_by_slug(params[:slug])
    raise ActionController::RoutingError.new("無此分類") if not @category
    @categories = Category.all
    # @groups = Post.group_by_year.each do |year,posts|
    #   posts.delete_if {|post| post[:category_id] != @category[:id]}
    # end
    # @groups.each { |key,value| @groups.delete(key) if value.length == 0 }
    @posts = Post.where(:category_id => @category[:id]).order(:display_date => :desc)
  end

  def index
    categories = Category.all.map(&:name)
    render json: {categories: categories}
  end
end
