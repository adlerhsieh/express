class SubscriptionMailer < ApplicationMailer
  default from: "service@motion-express.com"

  def subscription(email,items)
    @email = email
    @items = items
    if @items.length > 1
      title = "特快車文章更新：#{@items.first.title}及其他文章"
    else
      title = "特快車文章更新：#{@items.first.title}"
    end
    mail(to: @email, subject: title) do |format|
      format.text
      format.html
    end
  end
end
