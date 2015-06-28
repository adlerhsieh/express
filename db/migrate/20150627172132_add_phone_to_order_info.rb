class AddPhoneToOrderInfo < ActiveRecord::Migration
  def change
    add_column :store_order_infos, :phone, :string
  end
end
