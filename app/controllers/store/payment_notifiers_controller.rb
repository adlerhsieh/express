class Store::PaymentNotifiersController < ApplicationController
  protect_from_forgery :except => [:create]

  def create
    Store::PaymentNotification.create!(:params => params.as_json)
    puts "notify_url is getting notified!!!!!"
    render :nothing => true
  end
end
