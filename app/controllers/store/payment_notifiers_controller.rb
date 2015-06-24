class Store::PaymentNotifiersController < ApplicationController
  protect_from_forgery :except => [:create]

  def create
    notification = Store::PaymentNotifier.create!(
      :params => params.as_json,
      :transaction_id => params[:txn_id],
      :order_id => params[:invoice],
      :status => params[:payment_status],
    )
    if notification.status == "Completed"
      order = Store::Order.find(notification.order_id)
      order.pay!
      order.update_pay_time
    end
    render :nothing => true
  end
end
