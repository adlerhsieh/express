class Store::PaymentNotifier < ActiveRecord::Base
  table_name = "store_payment_notifications"
  belongs_to :order, :class_name => "Store::Order", :foreign_key => "order_id"
end
