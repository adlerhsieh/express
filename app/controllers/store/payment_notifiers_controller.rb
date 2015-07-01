class Store::PaymentNotifiersController < ApplicationController
  protect_from_forgery :except => [:create]

  def create
    notification = Store::PaymentNotifier.create!(
      :params => params.as_json,
      :transaction_id => params[:txn_id],
      :order_id => params[:invoice],
      :status => params[:payment_status],
    )
    if payment_completed? && params_valid?
      order = Store::Order.find(notification.order_id)
      order.use_paypal
      order.pay!
      order.update_pay_time
      clear_current_cart
    end
    render :nothing => true
  end

  private

    def payment_completed?
      params[:payment_status] == "Completed"
    end

    def params_valid?
      params[:receiver_email] == ENV["paypal_seller_email"] && params[:receiver_id] == ENV["paypal_seller_id"]
    end
end
