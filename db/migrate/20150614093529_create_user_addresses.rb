class CreateUserAddresses < ActiveRecord::Migration
  def change
    create_table :user_addresses do |t|
      t.string :address
      t.string :phone
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
