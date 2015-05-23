module PostsHelper
  def render_author(text)
    link_to( text, author_path )
  end
  def render_blog_title(custom=nil)
    if custom
      content_tag(:h3, custom, class: "blog-title")
    else
      content_tag(:h3, "Blog", class: "blog-title")
    end
  end
  def previous_post_link
    if @previous_post
      content_tag :span, :style => "float:left" do
        content_tag(:span, "", :class => "glyphicon glyphicon-arrow-left") +
        " " +
        link_to(@previous_post.title, post_path(@previous_post[:slug]))
      end
    end
  end
  def next_post_link
    if @next_post
      content_tag :span, :style => "float: right" do
        link_to(@next_post.title, post_path(@next_post[:slug])) +
        " " +
        content_tag(:span, "", :class => "glyphicon glyphicon-arrow-right")
      end
    end
  end
end
