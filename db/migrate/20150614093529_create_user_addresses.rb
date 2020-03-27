class CreateUserAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :user_addresses do |t|
      t.string :address
      t.string :phone
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
