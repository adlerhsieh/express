# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/notify_paid
  def notify_paid
    OrderMailer.notify_paid
  end

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/notify_shipped
  def notify_shipped
    OrderMailer.notify_shipped
  end

end
