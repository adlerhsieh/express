class AddPhoneToOrderInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :store_order_infos, :phone, :string
  end
end
