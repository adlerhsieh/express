namespace :migrate do
  task translation: :environment do
    Post.all.each do |post|
      content = ActiveRecord::Base.connection.execute("select content from post_translations where post_id = #{post.id} and locale = 'zh-TW'").entries.try(:first).try(:first)

      post.update_column(:content, content) if content
    end

    Training.all.each do |training|
      content = ActiveRecord::Base.connection.execute("select content from training_translations where training_id = #{training.id} and locale = 'zh-TW'").entries.try(:first).try(:first)

      training.update_column(:content, content) if content
    end

    Screencast.all.each do |screencast|
      content = ActiveRecord::Base.connection.execute("select content from screencast_translations where screencast_id = #{screencast.id} and locale = 'zh-TW'").entries.try(:first).try(:first)

      screencast.update_column(:content, content) if content
    end

  end
end
