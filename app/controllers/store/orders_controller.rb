class Store::OrdersController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:add_to_cart]
  before_action :set_order, only: [:place, :destroy, :update_quantity]
  before_filter :require_account, only: [:place]
  #
  def index
    # @orders = User.includes(:orders => [:items, :info]).find_by_id(session[:user_id]).orders
    @orders = current_user.orders.all.order(:created_at => :desc)
  end

  def show
    @order = Store::Order.includes(:items => [:product]).find_by_token(params[:id])
    @order_info = @order.info || Store::OrderInfo.new
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

  def require_account
    redirect_to require_sign_in_users_path unless current_user
  end

  def update_quantity
    @order.items.each do |i|
      num = params[i.id.to_s.to_sym]
      i.update_column(:quantity, num.to_i) if !num.nil? && num.to_i > 0
    end
    flash[:notice] = "數量已更新！"
    redirect_to store_order_path(@order)
  end

  private
    def set_order
      @order = Store::Order.find_by_token(params[:id])
    end
end
