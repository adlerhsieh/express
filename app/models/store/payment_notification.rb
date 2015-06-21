class Store::PaymentNotification < ActiveRecord::Base
  belongs_to :order, :class_name => "Store::Order", :foreign_id => "order_id"
end
