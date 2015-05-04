task :compact do
  dir = "/Users/hsiehadler/Dropbox/文件/Motion Express/hexo/source/_posts"
  posts = Dir.entries(dir).delete_if {|e| [".", "..", ".DS_Store"].include? e }
  posts.each do |post|
    puts "Writing to: " + post
    content = File.read(dir + "/" + post)
    content.gsub!("<snippet>", "`")
    content.gsub!("</snippet>", "`")
    content.gsub!("<!--more-->", "")
    content.gsub!("<pre>", "```")
    content.gsub!("</pre>", "```")
    File.open(dir + "/" + post, "w:UTF-8") {|file| file.write(content) }
    # new_content = "# encoding: utf-8\n\n" + content
    # File.open(dir + "/" + post, "r+") {|file| file.write(new_content) }
  end
end
