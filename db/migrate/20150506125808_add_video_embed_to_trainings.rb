class AddVideoEmbedToTrainings < ActiveRecord::Migration[6.0]
  def change
    add_column :trainings, :video_embed, :string, :after => :content
  end
end
