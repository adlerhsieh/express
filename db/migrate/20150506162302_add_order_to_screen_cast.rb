class AddOrderToScreenCast < ActiveRecord::Migration
  def change
    add_column :screen_casts, :training_order, :integer
  end
end
