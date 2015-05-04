class CreateTrainings < ActiveRecord::Migration
  def change
    create_table :trainings do |t|
      t.string :title
      t.text :content
      t.string :image_src

      t.timestamps null: false
    end
  end
end
