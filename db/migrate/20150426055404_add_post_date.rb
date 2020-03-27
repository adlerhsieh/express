class AddPostDate < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :display_date, :date
  end
end
