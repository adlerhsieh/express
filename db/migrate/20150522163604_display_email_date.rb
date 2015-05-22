class DisplayEmailDate < ActiveRecord::Migration
  def change
    Post.all.each {|p| p.update_column(:sent, nil) }
    change_column :posts, :sent, :date, :default => nil
  end
end
