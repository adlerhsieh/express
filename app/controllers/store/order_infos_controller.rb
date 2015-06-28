class Store::OrderInfosController < ApplicationController
  before_action :set_order
  def create
    @info = @order.info
    if @info
      @order.info.update!(info_params)
    else
      info = Store::OrderInfo.create!(info_params)
      @order.info = info
    end
    flash[:notice] = "寄送資訊已更新"
    redirect_to store_order_path(@order)
  end

  private
    def set_order
      @order = Store::Order.find_by_token(params[:order_id])
    end

    def info_params
      params.permit(:shipping_name, :shipping_address, :phone)
    end
end
