module PostsHelper
  def render_blog_title(custom=nil)
    if custom
      content_tag(:h3, custom, class: "blog-title")
    else
      content_tag(:h3, "Blog", class: "blog-title")
    end
  end
end
