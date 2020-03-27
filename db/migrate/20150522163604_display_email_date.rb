class DisplayEmailDate < ActiveRecord::Migration[6.0]
  def change
    Post.all.each {|p| p.update_column(:sent, nil) }
    change_column :posts, :sent, :date, :default => nil
  end
end
