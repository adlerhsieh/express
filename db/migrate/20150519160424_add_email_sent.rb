class AddEmailSent < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :sent, :boolean, :default => false
  end
end
