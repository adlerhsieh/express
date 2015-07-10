class Store::PaymentNotifiersController < ApplicationController
  protect_from_forgery :except => [:create]
  before_action :set_notifier, :except => [:create]

  def create
    notification = Store::PaymentNotifier.create!(
      :params => params.as_json,
      :transaction_id => params[:txn_id],
      :order_id => params[:invoice],
      :status => params[:payment_status],
    )
    if payment_completed? && params_valid?
      order = Store::Order.find(notification.order_id)
      order.pay_with_paypal!
      order.takes_stock
      order.notify_admin(:paypal)
      clear_current_cart
      OrderMailer.notify_paid(order).deliver_now
    end
    render :nothing => true
  end

    def cancel
      @notifier.update_column(:status, "Cancelled")
      @order.cancel_paid!
      @order.clear_timestamp(:pay_time)
      flash[:notice] = "已將訂單退回未付款狀態"
      redirect_to :back
    end

    def confirm
      @notifier.update_column(:status, "Completed")
      @order.pay!
      @order.timestamp(:pay_time)
      flash[:notice] = "已確認PayPal有入帳"
      redirect_to :back
    end

    def recover
      @notifier.update_column(:status, "Completed")
      @order.pay_with_paypal!
      @order.update_column(:pay_time, @notifier[:created_at])
      flash[:notice] = "已回復原本交易為正常"
      redirect_to :back
    end

  private
    def set_notifier
      @notifier = Store::PaymentNotifier.includes(:order).find(params[:id])
      @order = @notifier.order
    end

    def payment_completed?
      params[:payment_status] == "Completed"
    end

    def params_valid?
      params[:receiver_email] == ENV["paypal_seller_email"] && params[:receiver_id] == ENV["paypal_seller_id"]
    end
end
