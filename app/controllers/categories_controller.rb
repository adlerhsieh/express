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

  def destroy
    @category = Category.find(params[:id])
    Post.all.each do |p|
      if p[:category_id] == @category[:id]
        p.update_column(:category_id, nil)
      end
    end
    @category.delete
    redirect_to edit_categories_path(current_user[:name])
  end

  def update_all
    params[:categories].each do |key, category|
      @category = Category.find(category["id"])
      @category.update!(category.permit("name", "slug"))
    end
    render json: "success"
  end
end
