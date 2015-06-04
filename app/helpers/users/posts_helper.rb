module Users::PostsHelper
  def mail_toggle_button(post)
    # path = send_post_email_user_path(current_user["name"],post[:id])
    if post.sent
      content_tag(:button, post.sent.strftime("%Y-%m-%d"), :class => "btn btn-default email_send", style: "width: 100px;", data: post.id.to_s)
      # link_to post.sent.strftime("%Y-%m-%d"), path, method: :post, data: { confirm: "確定再次發送？" }, class: "btn btn-default", style: "width: 100px;"
    else
      content_tag(:button, "發送email", :class => "btn btn-success email_send", style: "width: 100px;", data: post.id.to_s)
      # link_to "發送Email", path, method: :post, data: { confirm: "確定發送？" }, class: "btn btn-success", style: "width: 100px;"
    end
  end
end
