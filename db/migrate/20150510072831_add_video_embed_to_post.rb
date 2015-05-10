class AddVideoEmbedToPost < ActiveRecord::Migration
  def change
    add_column :posts, :video_embed, :text
  end
end
