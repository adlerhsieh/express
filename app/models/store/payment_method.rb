class Store::PaymentMethod < ActiveRecord::Base
  has_many :orders, :class_name => "Store::Order", :foreign_key => "payment_method_id"
end
