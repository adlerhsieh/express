class AddIconToScreencasts < ActiveRecord::Migration
  def change
    add_column :screencasts, :icon, :string
  end
end
