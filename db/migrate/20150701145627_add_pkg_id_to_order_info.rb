class AddPkgIdToOrderInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :store_order_infos, :pkg_id, :string
  end
end
