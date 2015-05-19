Setting.find_by_key("og_image").update_column(:tag, "社群分享：圖片")
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
