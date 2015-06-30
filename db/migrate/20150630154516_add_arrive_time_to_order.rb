class AddArriveTimeToOrder < ActiveRecord::Migration
  def change
    add_column :store_orders, :arrived_at, :datetime
    add_column :store_orders, :returned_at, :datetime
  end
end
