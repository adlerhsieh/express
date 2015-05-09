namespace :import do
  task :posts => :environment do
    categories = Category.all.map(&:name)
    db_tags = Tag.all.map(&:name)

    dir = "/Users/hsiehadler/Dropbox/文件/Motion Express/hexo/source/_posts"
    posts = Dir.entries(dir).delete_if {|e| [".", "..", ".DS_Store"].include? e }

    posts.each do |post|
      puts "Start creating new post: #{post}"
      @text_array = []
      def @text_array.search_index(text)
        self.each do |line|
          if line.index(text)
            return self.index(line)
          end
        end
        return nil
      end

      content = File.read(dir + "/" + post)
      content.each_line do |line|
        @text_array.push(line)
      end

      slug = post
      slug.gsub!(".markdown", "")
      slug.gsub!(".md", "")

      title_index = @text_array.search_index("title")
      @text_array[title_index].gsub!("title: ","")
      @text_array[title_index].gsub!("title:","")
      @text_array[title_index].gsub!("\n","")
      @text_array[title_index].gsub!("\"","")
      title = @text_array[0]

      category_index = @text_array.search_index("categories")
      if category_index
        @text_array[category_index + 1].gsub!("  - ","")
        @text_array[category_index + 1].gsub!(" ","")
        @text_array[category_index + 1].gsub!("\n","")
        category = @text_array[category_index + 1]
      else
        category = "未分類"
      end

      puts "Reading tags..."
      tag_index = @text_array.search_index("tags")
      puts "Current tag index is: " + tag_index.to_s || "none"
      if tag_index
        tags = []
        i = 1
        while @text_array[tag_index + i].index("  - ")
          current_tag = @text_array[tag_index + 1]
          current_tag.gsub!("  - ", "")
          current_tag.gsub!(" ", "")
          current_tag.gsub!("\n", "")
          tags.push(current_tag)
          i += 1
        end
      end

      date_index = @text_array.search_index("date")
      date = @text_array[date_index]
      date.gsub!("date: ", "")
      date = Date.parse(date)

      content_index = @text_array.search_index("---")
      content = @text_array[(content_index+1)..-1].join("")

      if categories.include? category 
        cat_id = Category.find_by_name(category)[:id]
      else
        cat = Category.create!(:name => category, :slug => category)
        categories.push(cat[:name])
        cat_id = cat[:id]
        puts "New category: ".green + "#{cat[:name]}"
      end

      new_post = Post.create!(
        title: title,
        content: content,
        slug: slug,
        category_id: cat_id,
        display_date: date,
        is_public: true
      )
      puts "New post: ".green + "#{new_post[:title]}"
      puts "Timestamp: #{new_post[:display_date]}"

      if tag_index
        tags.each do |tag|
          if db_tags.include? tag
            db_tag = Tag.find_by_name(tag)
            PostTag.create!(:post_id => new_post[:id], :tag_id => db_tag[:id])
          else
            new_tag = Tag.create!(:name => tag, :slug => tag)
            db_tags.push(tag)
            PostTag.create!(:post_id => new_post[:id], :tag_id => new_tag[:id])
            puts "New tag: ".green + "#{new_tag[:name]}"
          end
        end
      end
    end
  end

  task :meta => :environment do
    Setting.create!([
      {key: "site_title", value: "特快車 | Ruby、Rails、各式技術分享", tag: "網站標題"},
      {key: "meta_title", value: "特快車：Ruby、Rails、網路、開發技術分享", tag: "META標題"},
      {key: "meta_keywords", value: "ruby,rails,rspec,hexo,blog,tutorial,教學,技術分享", tag: "META關鍵字"},
      {key: "meta_description", value: "以Ruby on Rails為中心的各式網路開發技術分享，歡迎大家多指教", tag: "META說明"},
      {key: "og_title", value: "特快車 | Ruby、Rails、各式技術分享", tag: "社群分享：標題"},
      {key: "og_url", value: "http://motion-express.com", tag: "社群分享：連結網址"},
      {key: "og_site_name", value: "特快車 | Ruby、Rails、各式技術分享", tag: "社群分享：網站名稱"},
      {key: "og_description", value: "以Ruby on Rails為中心的各式網路開發技術分享，歡迎大家多指教", tag: "社群分享：說明"},
      {key: "favicon_location", value: "/favicon.png", tag: "網站Favicon"},
      {key: "ga", value: "<script>   (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){   (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),   m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)   })(window,document,'script','//www.google-analytics.com/analytics.js','ga');    ga('create', 'UA-37175845-6', 'auto');   ga('send', 'pageview');  </script>", tag: "GA程式碼"}
    ])
  end
end
