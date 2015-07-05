class Store::PaymentTransfersController < ApplicationController
  before_action :set_order
  before_filter :txn_id_format, only: [:create, :update]

  def new
    @transfer = Store::PaymentTransfer.new
  end

  def create
    @transfer = Store::PaymentTransfer.new(transfer_params)
    t = @transfer.transaction_id
    if @transfer.save
      @order.transfer = @transfer
      @order.under_transfer!
      @order.use_transfer
      @order.notify_admin(:transfer)
      flash[:notice] = "成功送出轉帳資訊，我們已收到通知，將儘速為您確認！"
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
    if @transfer.update!(transfer_params) 
      @order.notify_admin(:transfer,:update)
      flash[:notice] = "轉帳資訊更新成功，我們已收到通知，將儘速為您確認！"
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
      @order.clear_payment_method
      flash[:notice] = "刪除成功"
      redirect_to store_order_path(@order)
    end
  end

  def confirm
    @transfer = Store::PaymentTransfer.find_by_order_id(@order.id)
    @transfer.confirm!
    @order.pay!
    @order.timestamp(:pay_time)
    OrderMailer.notify_paid(@order).deliver_now
    flash[:notice] = "確認成功"
    redirect_to store_order_path(@order)
  end

  def cancel_confirm
    @transfer = Store::PaymentTransfer.find_by_order_id(@order.id)
    @transfer.cancel_confirm!
    @order.under_transfer!
    @order.clear_timestamp(:pay_time)
    flash[:notice] = "取消轉帳資訊的確認"
    redirect_to :back
  end

  private
    def txn_id_format
      t = params[:store_payment_transfer][:transaction_id]
      if not t.length == 5 && t.to_i.to_s.length == 5
        flash[:alert] = "請確認已填入轉帳帳號末五碼"
        # render :new if params[:action] == "create"
        # render :edit if params[:action] == "update"
        redirect_to :back
      end
    end

    def set_order
      @order = Store::Order.find_by_token(params[:order_id])
    end

    def transfer_params
      params.require(:store_payment_transfer).permit(:transaction_id)
    end
end
