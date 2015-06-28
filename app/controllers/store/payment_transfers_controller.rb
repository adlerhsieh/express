class Store::PaymentTransfersController < ApplicationController
  before_action :set_order

  def new
    @transfer = @order.transfers.new
  end

  def create
    
  end

  private
    def set_order
      @order = Store::Order.find_by_token(params[:order_id])
    end
end
