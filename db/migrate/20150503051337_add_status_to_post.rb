class AddStatusToPost < ActiveRecord::Migration
  def up
    add_column :posts, :is_public, :boolean, :default => false
    Post.all.each do |p|
      p.update_column(:is_public, true)
    end
  end

  def down
    remove_column :posts, :is_public
  end

end
