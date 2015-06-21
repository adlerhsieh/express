class Store::Image < ActiveRecord::Base
  belongs_to :product, :class_name => "Stock::Product", :foreign_key => "product_id"
  validates_presence_of :image
end
