class Store::OrdersController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:add_to_cart]
  before_action :set_order, except: [:index, :show]
  before_filter :require_account, only: [:place]
  #
  def index
    if current_user.is_admin
      @orders = Store::Order.all.order(:created_at => :desc)
      @current_orders = @orders.where.not(:aasm_state => ["cancelled", "returned", "arrived"])
      @past_orders = @orders.where(:aasm_state => ["cancelled", "returned", "arrived"])
    else
      @orders = current_user.orders.where.not(:aasm_state => "cancelled").order(:created_at => :desc)
      @current_orders = @orders.where.not(:aasm_state => ["cancelled", "returned", "arrived"])
      @past_orders = @orders.where(:aasm_state => ["cancelled", "returned", "arrived"])
    end
  end

  def show
    @order = Store::Order.includes(:transfer, :info, :notifiers, :items => [:product]).find_by_token(params[:id])
    require_order_user
    @order_info = @order.info || Store::OrderInfo.new
    @transfer = @order.transfer
    @notifiers = @order.notifiers
    @notifier = @notifiers.order(:updated_at => :desc).first
  end

  def place
    @order.place!
    @order.timestamp(:order_time)
    flash[:notice] = "下單成功！"
    redirect_to store_order_path(@order)
  end

  def ship
    @order.ship!
    @order.timestamp(:shipping_time)
    flash[:notice] = "已設定為出貨"
    redirect_to :back
  end

  def cancel_ship
    @order.cancel_ship!
    @order.clear_timestamp(:shipping_time)
    flash[:notice] = "已取消出貨"
    redirect_to :back
  end

  def arrive
    @order.arrive!
    @order.timestamp(:arrived_at)
    flash[:notice] = "已設定為到貨"
    redirect_to :back
  end

  def cancel_arrive
    @order.cancel_arrive!
    @order.clear_timestamp(:arrived_at)
    flash[:notice] = "已退回至出貨"
    redirect_to :back
  end

  def return
    @order.return!
    @order.timestamp(:returned_at)
    flash[:notice] = "已設定為退貨"
    redirect_to :back
  end

  def cancel_return
    @order.cancel_return!
    @order.clear_timestamp(:returned_at)
    flash[:notice] = "已取消退貨"
    redirect_to :back
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
    @order.update_total_price
    flash[:notice] = "數量已更新！"
    redirect_to store_order_path(@order)
  end

  def note
    @order.update_column(:note, params[:note]) 
    flash[:notice] = "註記已更新"
    redirect_to :back
  end

  def cancel
    @order.cancel!
    @order.timestamp(:cancelled_at)
    flash[:notice] = "訂單已作廢"
    redirect_to :back
  end

  private
    def set_order
      @order = Store::Order.find_by_token(params[:id])
    end

    def require_order_user
      unless is_admin?
        unless @order.cart?
          if not current_user
            redirect_to store_products_path 
          elsif not current_user.id == @order.user.id
            redirect_to store_products_path 
          end
        end
      end
    end
end
