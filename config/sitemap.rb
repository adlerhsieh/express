# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://motion-express.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  add author_path
  add posts_path
  add trainings_path
  Post.find_each do |p|
    add post_path(p[:slug]), :lastmod => p[:updated_at]
  end
  Screencast.find_each do |s|
    add training_screencast_path(s.training[:slug], s[:slug]), :lastmod => s[:updated_at]
  end
  Category.find_each do |c|
    add category_path(c[:slug]), :lastmod => c[:updated_at]
  end
end
