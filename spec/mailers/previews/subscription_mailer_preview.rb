# Preview all emails at http://localhost:3000/rails/mailers/subscription_mailer
class SubscriptionMailerPreview < ActionMailer::Preview

  def subscription
    @email = SubscriptionMailer.subscription("123")
  end
end
