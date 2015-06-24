class Store::PaymentNotifiersController < ApplicationController
  protect_from_forgery :except => [:create]

  def create
    Store::PaymentNotifier.create!(
      :params => params.as_json,
      :transaction_id => params[:txn_id],
      :order_id => params[:invoice],
      :status => params[:payment_status],
    )
    render :nothing => true
  end
end
