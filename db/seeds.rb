time_2 = Time.now
[Post, Screencast, Training].each do |m|
  m.all.each do |p|
    time_1 = Time.now
    content = p.content
    if /\$\S/ =~ content
      content.gsub!("$", "$ ")
    end
    content.gsub!("```cmd", "```nohighlight")
    p.update_column(:content, content)
    # p.save!
    puts "Updated: #{p.title} (#{Time.now - time_1}s)"
  end
end

puts "Done (#{Time.now - time_2}s)"
[Post, Screencast, Training].each do |m|
  m.all.each do |p|
    case p.category_id
    when 11
      p.update_column(:category_id, 6)
      puts "#{p.title}: 類別已修正"
    when 12
      p.update_column(:category_id, 7)
      puts "#{p.title}: 類別已修正"
    when 13
      p.update_column(:category_id, 10)
      puts "#{p.title}: 類別已修正"
    when 14
      p.update_column(:category_id, 3)
      puts "#{p.title}: 類別已修正"
    end
  end
end

Post.find(75).update_column(:category_id, 7)

Category.find(11).delete
Category.find(12).delete
Category.find(13).delete
Category.find(14).delete
puts "duplicate categories removed"

Category.find_by_name("閒話家常").update_column(:image, "https://farm6.staticflickr.com/5338/17930311512_054045edf0_s.jpg")
Category.find_by_name("專題文章").update_column(:image, "http://i.imgur.com/QPcEqcb.png")
Category.find_by_name("AfterEffects").update_column(:image, "https://farm9.staticflickr.com/8756/16852715074_ab4b2858b0_s.jpg")
Category.find_by_name("推薦內容").update_column(:image, "http://i.imgur.com/Vq1H58Q.png")
Category.find_by_name("Rails研究室").update_column(:image, "http://i.imgur.com/TFH3UC0.png")
Category.find_by_name("Ruby整理").update_column(:image, "http://i.imgur.com/kqIiiLT.jpg")
Category.find_by_name("Vim").update_column(:image, "https://farm8.staticflickr.com/7432/16346519668_ed5670acb1_s.jpg")
Category.find_by_name("blog").update_column(:image, "https://farm9.staticflickr.com/8831/17933276225_56a8639a74_s.jpg")
puts "categories images updated"
