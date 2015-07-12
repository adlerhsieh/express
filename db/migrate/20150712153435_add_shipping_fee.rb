class AddShippingFee < ActiveRecord::Migration
  def change
    add_column :store_order_infos, :shipping_fee, :integer
  end
end
