class AddImageToCategoriesAndPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :image, :string
    add_column :categories, :image, :string
  end
end
