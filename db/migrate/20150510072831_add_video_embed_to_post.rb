class AddVideoEmbedToPost < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :video_embed, :text
  end
end
