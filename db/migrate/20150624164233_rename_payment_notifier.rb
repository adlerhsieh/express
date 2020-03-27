class RenamePaymentNotifier < ActiveRecord::Migration[6.0]
  def change
    rename_table :store_payment_notifications, :store_payment_notifiers
  end
end
