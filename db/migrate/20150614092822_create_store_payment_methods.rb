class CreateStorePaymentMethods < ActiveRecord::Migration[6.0]
  def change
    create_table :store_payment_methods do |t|
      t.string :method

      t.timestamps null: false
    end
  end
end
