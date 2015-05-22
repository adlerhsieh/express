class CategoriesController < ApplicationController
  def show
    @category = Category.find_by_slug(params[:slug])
    raise ActionController::RoutingError.new("無此分類") if not @category
    @categories = Category.all
    @posts = Post.where(:category_id => @category[:id]).where(:is_public => true).order(:display_date => :desc).page(params[:page])
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
    redirect_to edit_all_user_categories_path(current_user[:name])
  end

  def update_all
    params[:categories].each do |key, category|
      @category = Category.find(category["id"])
      @category.update!(category.permit("name", "slug", "image"))
    end
    render json: "success"
  end
end
