class Store::PaymentTransfersController < ApplicationController
  before_action :set_order

  def new
    @transfer = Store::PaymentTransfer.new
  end

  def create
    @transfer = Store::PaymentTransfer.new(transfer_params)
    t = @transfer.transaction_id
    if @transfer.save && t.to_i.to_s.length == 5
      @order.transfer = @transfer
      @order.under_transfer!
      flash[:notice] = "已送出轉帳資訊"
      redirect_to store_order_path(@order)
    else
      flash[:alert] = "請確認已填入轉帳帳號末五碼"
      render :new
    end
  end

  def edit
    @transfer = @order.transfer
  end

  def update
    @transfer = Store::PaymentTransfer.find_by_order_id(@order.id)
    t = @transfer.transaction_id
    if @transfer.update!(transfer_params) && t.to_i.to_s.length == 5
      flash[:notice] = "轉帳資訊更新成功"
      redirect_to store_order_path(@order)
    else
      flash[:alert] = "請確認已填入轉帳帳號末五碼"
      render :edit
    end
  end

  def destroy
    @transfer = Store::PaymentTransfer.find_by_order_id(@order.id)
    if @transfer
      @transfer.delete
      @order.cancel_transfer!
      flash[:notice] = "刪除成功"
      redirect_to store_order_path(@order)
    end
  end

  private
    def set_order
      @order = Store::Order.find_by_token(params[:order_id])
    end

    def transfer_params
      params.require(:store_payment_transfer).permit(:transaction_id)
    end
end
