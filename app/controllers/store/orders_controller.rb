class Store::OrdersController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:add_to_cart]
  before_action :set_order, only: [:place]
  # before_filter :authenticate_user!
  #
  def index
    # @orders = User.includes(:orders => [:items, :info]).find_by_id(session[:user_id]).orders
    @orders = current_user.orders.where.not(:aasm_state => "cart")
  end

  def show
    @order = Store::Order.includes(:items => [:product]).find_by_token(params[:id])
  end

  def place
    @order.place!
    @order.update_order_time
    session[:order_id] = nil
    flash[:notice] = "再點選一次按鈕前往結帳頁面！"
    redirect_to store_order_path(@order)
  end

  private
    def set_order
      @order = Store::Order.find_by_token(params[:id])
    end
end
