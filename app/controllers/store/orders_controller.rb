class Store::OrdersController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:add_to_cart]
  before_action :set_order, only: [:place, :destroy]
  # before_filter :authenticate_user!
  #
  def index
    # @orders = User.includes(:orders => [:items, :info]).find_by_id(session[:user_id]).orders
    @orders = current_user.orders.all.order(:created_at => :desc)
  end

  def show
    @order = Store::Order.includes(:items => [:product]).find_by_token(params[:id])
  end

  def place
    @order.place!
    @order.update_order_time
    flash[:notice] = "下單成功！"
    redirect_to store_order_path(@order)
  end

  def destroy
    @order.items.delete_all
    @order.delete
    flash[:notice] = "訂單已刪除"
    redirect_to store_orders_path
  end

  private
    def set_order
      @order = Store::Order.find_by_token(params[:id])
    end
end
