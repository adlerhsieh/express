I18n.locale = :"zh-TW"

# [Post, Screencast, Training].each do |model|
[Post].each do |m|
  m.all.each do |p|
    puts "Translating: #{p.title}"
    p.save
  end
end

Category.all.each do |c|
  puts "Translating: #{c.name}"
  c.save
end

unless Setting.find_by_key("og_image")
  Setting.create!(
    :key => "og_image",
    :value => "https://farm9.staticflickr.com/8744/17682286022_b07643d870_o.jpg"
  )
end
