class ChangeMethodToName < ActiveRecord::Migration
  def change
    rename_column :store_payment_methods, :method, :name
  end
end
