class Store::PaymentTransfersController < ApplicationController
  before_action :set_order

  def new
    @transfer = @order.transfers.new
  end

  def create
    @transfer = @order.transfers.new(transfer_params)
    if @transfer.save
      flash[:notice] = "已送出轉帳資訊"
      redirect_to store_order_path(@order)
    else
      flash[:alert] = "請確認已填入轉帳帳號末五碼"
      render :new
    end
  end

  def edit
    @transfer = @order.transfers.last
  end

  def update
    
  end

  private
    def set_order
      @order = Store::Order.find_by_token(params[:order_id])
    end

    def transfer_params
      params.require(:store_payment_transfer).permit(:transaction_id)
    end
end
