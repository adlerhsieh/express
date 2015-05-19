# Preview all emails at http://localhost:3000/rails/mailers/subscription_mailer
class SubscriptionMailerPreview < ActionMailer::Preview

  def subscription
    @email = SubscriptionMailer.subscription("nkj20932@hotmail.com",Array.new(1, Post.last))
  end
end
