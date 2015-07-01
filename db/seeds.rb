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

unless User::Email.all.any?
  User::Email.create(blog_subscription: true, address: "42thcoder@gmail.com")
  User::Email.create(blog_subscription: true, address: "781260203@qq.com")
  User::Email.create(blog_subscription: true, address: "a20209598@gmail.com")
  User::Email.create(blog_subscription: true, address: "acsd68500@gmail.com")
  User::Email.create(blog_subscription: true, address: "cstony0917@gmail.com")
  User::Email.create(blog_subscription: true, address: "dars94@gmail.com")
  User::Email.create(blog_subscription: true, address: "nkj20932@hotmail.com")
end

unless Store::PaymentMethod.all.any?
  Store::PaymentMethod.create(:name => "匯款")
  Store::PaymentMethod.create(:name => "PayPal")
end
