class Store::OrdersController < ApplicationController
  before_action :require_login
  skip_before_filter :verify_authenticity_token, only: [:add_to_cart]
  # before_filter :authenticate_user!

  def add_to_cart
    cart = current_user.cart
    result = cart.add_item(params[:id])
    render json: "已加入購物車：#{result[:title]}，數量#{result[:quantity]}，總價#{result[:price]}"
  end
end
