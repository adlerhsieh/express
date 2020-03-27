class AddNoteToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :store_orders, :note, :text
  end
end
