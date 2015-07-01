class OrderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.notify_paid.subject
  #
  def notify_paid(transfer)
    @transfer = transfer
    @order = transfer.order
    email = transfer.order.user.email
    subject = "訂單編號：#{transfer.order.token[0..7]} 付款已成功！"

    mail(from: "info@motion-express.com", to: email, subject: subject) do |format|
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
