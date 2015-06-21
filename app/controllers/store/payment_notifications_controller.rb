class Store::PaymentNotification < ApplicationController
  protect_from_forgery :except => [:create]

  def create
    Store::PaymentNotification.create!(:params => params.as_json)
    render :nothing => true
  end
end
