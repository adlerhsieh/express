class CreateUserMails < ActiveRecord::Migration
  def change
    create_table :user_mails do |t|
      t.string :address
      t.boolean :blog_scription
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
