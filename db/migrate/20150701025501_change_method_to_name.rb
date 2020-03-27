class ChangeMethodToName < ActiveRecord::Migration[6.0]
  def change
    rename_column :store_payment_methods, :method, :name
  end
end
