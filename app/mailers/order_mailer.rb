class OrderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.notify_paid.subject
  #
  def notify_paid(order)
    @order = order
    @info = @order.info
    email = @order.user.email
    subject = "訂單：#{@order.token} 付款成功！"

    mail(to: email, subject: subject) do |format|
      format.text
      format.html
    end
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.notify_shipped.subject
  #
  def notify_shipped
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
