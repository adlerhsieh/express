class AddIconColumnToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :icon, :string
  end
end
