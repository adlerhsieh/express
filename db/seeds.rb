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

User.create!([
  {email: "nkj20932@hotmail.com", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2015-05-03 05:03:33", last_sign_in_at: "2015-05-03 05:03:33", current_sign_in_ip: "::1", last_sign_in_ip: "::1", is_admin: true, name: "adler", password: "12345678", password_confirmation: "12345678"}
])
