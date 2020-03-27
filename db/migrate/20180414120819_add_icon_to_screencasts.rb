class AddIconToScreencasts < ActiveRecord::Migration[6.0]
  def change
    add_column :screencasts, :icon, :string
  end
end
