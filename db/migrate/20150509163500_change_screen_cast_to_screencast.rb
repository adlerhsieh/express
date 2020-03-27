class ChangeScreenCastToScreencast < ActiveRecord::Migration[6.0]
  def up
    rename_table :screen_casts, :screencasts
  end
  def down
    rename_table :screencasts, :screen_casts
  end
end
