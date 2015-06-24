class CreateStoreImages < ActiveRecord::Migration
  def change
    create_table :store_images do |t|
      t.string :image
      t.integer :product_id

      t.timestamps null: false
    end
  end
end
