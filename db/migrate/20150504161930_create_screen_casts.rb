class CreateScreenCasts < ActiveRecord::Migration[6.0]
  def change
    create_table :screen_casts do |t|
      t.string :title
      t.string :video_embed
      t.text :content
      t.string :training_id

      t.timestamps null: false
    end
  end
end
