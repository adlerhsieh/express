class Store::OrdersController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:add_to_cart]
  before_action :set_order, only: [:place]
  # before_filter :authenticate_user!
  #
  def show
    @order = Store::Order.includes(:items => [:product]).find_by_token(params[:id])
  end

  def place
    @order.place!
    session[:order_id] = nil
    redirect_to store_order_path(@order)
  end

  private
    def set_order
      @order = Store::Order.find_by_token(params[:id])
    end
end
