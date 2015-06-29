class AddNoteToOrder < ActiveRecord::Migration
  def change
    add_column :store_orders, :note, :text
  end
end
