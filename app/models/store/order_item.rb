class Store::OrderItem < ActiveRecord::Base
  belongs_to :order, :class_name => "Store::Order", :foreign_key => "order_id"
  belongs_to :product, :class_name => "Store::Product", :foreign_key => "product_id"
end
