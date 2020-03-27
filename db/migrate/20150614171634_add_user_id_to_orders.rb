class AddUserIdToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :store_orders, :user_id, :integer
  end
end
