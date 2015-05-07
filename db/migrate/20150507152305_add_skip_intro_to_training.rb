class AddSkipIntroToTraining < ActiveRecord::Migration
  def change
    add_column :trainings, :skip, :boolean, :default => true
  end
end
