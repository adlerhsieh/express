class AddCancelledAtToOrder < ActiveRecord::Migration
  def change
    add_column :store_orders, :cancelled_at, :datetime
  end
end
