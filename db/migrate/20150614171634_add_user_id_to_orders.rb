class AddUserIdToOrders < ActiveRecord::Migration
  def change
    add_column :store_orders, :user_id, :integer
  end
end
