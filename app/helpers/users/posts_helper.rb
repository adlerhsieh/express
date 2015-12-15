module Users::PostsHelper
  def mail_toggle_button(post)
    if post.sent
      content_tag(:button, post.sent.strftime("%Y-%m-%d"), :class => "btn btn-default email_send", style: "width: 100px;", data: post.id.to_s)
    else
      content_tag(:button, "發送email", :class => "btn btn-success email_send", style: "width: 100px;", data: post.id.to_s)
    end
  end
end
