class CreateStorePaymentMethods < ActiveRecord::Migration
  def change
    create_table :store_payment_methods do |t|
      t.string :method

      t.timestamps null: false
    end
  end
end
