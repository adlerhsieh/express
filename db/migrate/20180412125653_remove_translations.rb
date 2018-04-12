class RemoveTranslations < ActiveRecord::Migration
  def change
    drop_table :category_translations
    drop_table :post_translations
    drop_table :screencast_translations
    drop_table :setting_translations
    drop_table :training_translations
    drop_table :tag_translations
  end
end
