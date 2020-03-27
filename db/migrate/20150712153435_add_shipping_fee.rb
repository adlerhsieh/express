class AddShippingFee < ActiveRecord::Migration[6.0]
  def change
    add_column :store_orders, :shipping_fee, :integer, :default => 0
  end
end
