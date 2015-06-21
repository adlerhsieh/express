class CreateStorePaymentNotifications < ActiveRecord::Migration
  def change
    create_table :store_payment_notifications do |t|
      t.text :params
      t.integer :order_id
      t.string :status
      t.string :transaction_id

      t.timestamps null: false
    end
  end
end
