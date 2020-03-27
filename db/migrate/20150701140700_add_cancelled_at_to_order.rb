class AddCancelledAtToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :store_orders, :cancelled_at, :datetime
  end
end
