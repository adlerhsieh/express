class SetIsPublicToDefaultFalse < ActiveRecord::Migration[6.0]
  def change
    change_column :trainings, :is_public, :boolean, :default => false
    change_column :screen_casts, :is_public, :boolean, :default => false
  end
end
