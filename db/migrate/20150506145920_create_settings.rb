class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.string :key
      t.text :value

      t.timestamps null: false
    end
  end
end
