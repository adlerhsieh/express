class CreateTranslations < ActiveRecord::Migration[6.0]
  def up
    # Post.create_translation_table!({:title => :string, :content => :text}, {migration_data: true})
    # Screencast.create_translation_table!({:title => :string, :content => :text}, {migration_data: true})
    # Training.create_translation_table!({:title => :string, :content => :text}, {migration_data: true})
    # Tag.create_translation_table!({:name => :string}, {migration_date: true})
    # Category.create_translation_table!({:name => :string}, {migration_date: true})
    # Setting.create_translation_table!({:value => :text}, {migration_date: true})
  end

  def down
    # Post.drop_translation_table!
    # Screencast.drop_translation_table!
    # Training.drop_translation_table!
    # Tag.drop_translation_table!
    # Category.drop_translation_table!
    # Setting.drop_translation_table!
  end
end
