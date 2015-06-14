class Store::ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update, :show, :destroy, :toggle_display]

  def index
    
  end

  def new
    @product = Store::Product.new
  end

  def create
    @product = Store::Product.new(product_params)
    if @product.save
      flash[:notice] = "已建立新商品：#{@product.title}"
      redirect_to store_products_path
    else
      render :new
    end
  end

  def edit
    
  end

  def update
    
  end

  def show
    if is_admin?
      redirect_to store_products_path
      return
    end
  end

  def destory
    @product.delete
    flash[:notice] = "產品已刪除"
    redirect_to store_products_path
  end
  
  def toggle_display
    if @product.display
      @product.update_column(:display, false)
    else
      @product.update_column(:display, true)
    end
    render json: @product.display
  end

  private
    def set_product
      @product = Store::Product.find(params[:id])
    end

    def product_params
      params.require(:store_product).permit(:title, :description, :stock, :price, :default_image, :category_id, :display)
    end
end
