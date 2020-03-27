class CreateStoreProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :store_products do |t|
      t.string :title
      t.string :description
      t.integer :stock
      t.integer :price
      t.string :default_image
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
