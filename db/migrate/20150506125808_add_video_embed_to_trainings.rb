class AddVideoEmbedToTrainings < ActiveRecord::Migration
  def change
    add_column :trainings, :video_embed, :string, :after => :content
  end
end
