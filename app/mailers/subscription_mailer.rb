class SubscriptionMailer < ApplicationMailer
  default from: "service@motion-express.com"

  def hello(email)
    
    mail to: email, subject: "測試Email"
  end
end
