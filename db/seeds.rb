# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

dir = "/Users/hsiehadler/Dropbox/文件/Motion Express/hexo/source/_posts"
posts = Dir.entries(dir).delete_if {|e| [".", "..", ".DS_Store"].include? e }

content = File.read(dir + "/" + posts.last)
@text_array = []
content.each_line do |line|
  @text_array.push(line)
end

def @text_array.search_index(text)
  self.each do |line|
    if line.index(text)
      return self.index(line)
    end
  end
end


title_index = @text_array.search_index("title")
@text_array[title_index].gsub!("title: ","").gsub!("title:","")
title = @text_array[0]

category_index = @text_array.search_index("categories")
@text_array[category_index + 1].gsub!("  - ","")
category = @text_array[category_index + 1]

tag_index = @text_array.search_index("tags")
tags = []
i = 1
while @text_array[tag_index + i].index("  - ")
  current_tag = @text_array[tag_index + 1]
  current_tag.gsub!("  - ", "")
  tags.push(current_tag)
  i += 1
end

date_index = @text_array.search_index("date")
date = @text_array[date_index]
date.gsub!("date: ", "")
date = Date.parse(date)

content_index = @text_array.search_index("---")
content = @text_array[(content_index+1)..-1].join("")

puts title
puts category
puts tags
puts date
puts content
