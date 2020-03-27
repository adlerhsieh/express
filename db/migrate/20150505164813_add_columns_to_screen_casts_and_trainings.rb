class AddColumnsToScreenCastsAndTrainings < ActiveRecord::Migration[6.0]
  def change
    add_column :trainings, :slug, :string
    add_column :trainings, :display_date, :date
    add_column :trainings, :author_id, :integer
    add_column :trainings, :is_public, :boolean
    rename_column :trainings, :image_src, :image_embed

    add_column :screen_casts, :slug, :string
    add_column :screen_casts, :display_date, :date
    add_column :screen_casts, :image_embed, :string
    add_column :screen_casts, :author_id, :integer
    add_column :screen_casts, :is_public, :boolean
  end
end
