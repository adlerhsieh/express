class CreateStorePaymentTransfers < ActiveRecord::Migration[6.0]
  def change
    create_table :store_payment_transfers do |t|
      t.integer :order_id
      t.string :status
      t.string :transaction_id
      t.boolean :confirm
      t.datetime :confirm_time

      t.timestamps null: false
    end
  end
end
