class RemoveStores < ActiveRecord::Migration
  def change
    drop_table :store_categories
    drop_table :store_images
    drop_table :store_order_infos
    drop_table :store_order_items
    drop_table :store_orders
    drop_table :store_payment_methods
    drop_table :store_payment_notifiers
    drop_table :store_payment_transfers
    drop_table :store_products
    drop_table :user_products
  end
end
