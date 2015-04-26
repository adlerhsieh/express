class CategoriesController < ApplicationController
  def show
    @category = Category.find_by_name(params[:name])
    raise ActionController::RoutingError.new("無此分類") if not @category
    @categories = Category.all
    @groups = Post.group_by_year.each do |year,posts|
      posts.delete_if {|post| post[:category_id] != @category[:id]}
    end
  end
end
