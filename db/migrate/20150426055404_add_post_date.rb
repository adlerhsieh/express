class AddPostDate < ActiveRecord::Migration
  def change
    add_column :posts, :display_date, :date
  end
end
