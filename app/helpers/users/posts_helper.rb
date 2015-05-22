module Users::PostsHelper
  def mail_link(post)
    path = send_post_email_user_path(current_user["name"],post[:id])
    if post.sent
      link_to post.sent.strftime("%Y-%m-%d"), path, method: :post, data: { confirm: "確定再次發送？" }, class: "btn btn-default", style: "width: 100px;"
    else
      link_to "發送Email", path, method: :post, data: { confirm: "確定發送？" }, class: "btn btn-success", style: "width: 100px;"
    end
  end
end
