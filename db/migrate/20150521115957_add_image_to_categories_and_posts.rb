class AddImageToCategoriesAndPosts < ActiveRecord::Migration
  def change
    add_column :posts, :image, :string
    add_column :categories, :image, :string
  end
end
