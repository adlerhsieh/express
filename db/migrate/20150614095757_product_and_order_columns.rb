class ProductAndOrderColumns < ActiveRecord::Migration
  def change
    add_column :store_products, :display, :boolean, :default => false
    add_column :store_orders, :order_time, :datetime
    add_column :store_orders, :pay_time, :datetime
    add_column :store_orders, :shipping_time, :datetime
  end
end
