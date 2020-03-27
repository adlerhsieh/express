class AddSkipIntroToTraining < ActiveRecord::Migration[6.0]
  def change
    add_column :trainings, :skip, :boolean, :default => true
  end
end
