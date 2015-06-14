# time_2 = Time.now
# [Post, Screencast, Training].each do |m|
#   m.all.each do |p|
#     time_1 = Time.now
#     if /\$\S/ =~ p.content
#       p.content.gsub!("$", "$ ")
#     end
#     p.content.gsub!("```cmd", "```nohighlight")
#     # p.update_column(:content, content)
#     p.save!
#     puts "Syntax updated: #{p.title} (#{Time.now - time_1}s)"
#   end
# end

if user = User.find_by_email("nkj20932@hotmail.com")
  user.update_column(:is_admin, true)
end

