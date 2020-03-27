class AddCategoryToScreenCastsAndTrainings < ActiveRecord::Migration[6.0]
  def change
    add_column :screen_casts, :category_id, :integer
    add_column :trainings, :category_id, :integer
  end
end
