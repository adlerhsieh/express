class AddShippingFee < ActiveRecord::Migration
  def change
    add_column :store_orders, :shipping_fee, :integer, :default => 0
  end
end
