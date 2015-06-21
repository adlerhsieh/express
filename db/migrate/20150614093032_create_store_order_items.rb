class CreateStoreOrderItems < ActiveRecord::Migration
  def change
    create_table :store_order_items do |t|
      t.integer :quantity
      t.integer :price
      t.integer :order_id
      t.integer :product_id

      t.timestamps null: false
    end
  end
end
