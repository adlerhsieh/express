class OrderMailerPreview < ActionMailer::Preview
  def notify_paid
    OrderMailer.notify_paid(Store::Order.last)
  end
end
