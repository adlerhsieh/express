time_2 = Time.now
[Post, Screencast, Training].each do |m|
  m.all.each do |p|
    time_1 = Time.now
    content = p.content
    if /\$\S/ =~ content
      content.gsub!("$", "$ ")
    end
    content.gsub!("```cmd", "```nohighlight")
    # p.update_column(:content, content)
    p.save!
    puts "Updated & Translated: #{p.title} (#{Time.now - time_1}s)"
  end
end
puts "Done (#{Time.now - time_2}s)"

# I18n.locale = :"zh-TW"
#
# Setting.all.each do |s|
#   puts "Translating: #{s.tag}"
#   s.save
# end
#
# [Post, Screencast, Training].each do |m|
# # [Post].each do |m|
#   m.all.each do |p|
#     puts "Translating: #{p.title}"
#     p.save
#   end
# end
#
# Category.all.each do |c|
#   puts "Translating: #{c.name}"
#   c.save
# end
#
# unless Setting.find_by_key("og_image")
#   Setting.create!(
#     :key => "og_image",
#     :value => "https://farm9.staticflickr.com/8744/17682286022_b07643d870_o.jpg"
#   )
# end
