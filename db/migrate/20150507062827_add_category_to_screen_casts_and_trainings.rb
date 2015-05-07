class AddCategoryToScreenCastsAndTrainings < ActiveRecord::Migration
  def change
    add_column :screen_casts, :category_id, :integer
    add_column :trainings, :category_id, :integer
  end
end
