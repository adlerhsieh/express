class Store::Image < ActiveRecord::Base
  belongs_to :product, :class_name => "Stock::Product", :foreign_key => "product_id"
end
