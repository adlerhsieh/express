class CreateUserMails < ActiveRecord::Migration[6.0]
  def change
    create_table :user_emails do |t|
      t.string :address
      t.boolean :blog_subscription
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
