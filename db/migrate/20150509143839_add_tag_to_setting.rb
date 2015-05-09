class AddTagToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :tag, :string
  end
end
