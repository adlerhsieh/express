class EnlargeLimitForEmbedColumns < ActiveRecord::Migration[6.0]
  def change
    change_column :trainings, :video_embed, :text
    change_column :trainings, :image_embed, :text
    change_column :screen_casts, :image_embed, :text
    change_column :screen_casts, :video_embed, :text
  end
end
