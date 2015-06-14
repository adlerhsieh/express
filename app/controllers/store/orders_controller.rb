class Store::OrdersController < ApplicationController
  def add_to_cart
    render json: "success"
  end
end
