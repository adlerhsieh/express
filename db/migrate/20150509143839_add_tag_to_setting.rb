class AddTagToSetting < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :tag, :string
  end
end
