module Users::PostsHelper
  def mail_link(post)
    path = send_post_email_user_path(current_user["name"],post[:id])
    if post.sent
      link_to "Email訂閱已發", path, method: :post, data: { confirm: "確定再次發送？" }, class: "btn btn-default"
    else
      link_to "發送Email訂閱", path, method: :post, data: { confirm: "確定發送？" }, class: "btn btn-success"
    end
  end
end
