class RenamePaymentNotifier < ActiveRecord::Migration
  def change
    rename_table :store_payment_notifications, :store_payment_notifiers
  end
end
