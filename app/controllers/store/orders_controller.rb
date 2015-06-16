class Store::OrdersController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:add_to_cart]
  # before_filter :authenticate_user!
  def show
    @order = Store::Order.find_by_token(params[:id])
  end
end
