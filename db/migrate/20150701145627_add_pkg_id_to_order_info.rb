class AddPkgIdToOrderInfo < ActiveRecord::Migration
  def change
    add_column :store_order_infos, :pkg_id, :string
  end
end
