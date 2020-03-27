class AddOrderToScreenCast < ActiveRecord::Migration[6.0]
  def change
    add_column :screen_casts, :training_order, :integer
  end
end
