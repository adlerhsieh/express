class CreateStoreOrders < ActiveRecord::Migration
  def change
    create_table :store_orders do |t|
      t.integer :price
      t.boolean :paid
      t.string :token
      t.integer :payment_method_id
      t.string :aasm_state

      t.timestamps null: false
    end
  end
end
