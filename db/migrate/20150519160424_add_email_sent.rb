class AddEmailSent < ActiveRecord::Migration
  def change
    add_column :posts, :sent, :boolean, :default => false
  end
end
