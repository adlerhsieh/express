class SubscriptionMailer < ApplicationMailer
  default from: "service@motion-express.com"

  def subscription(email)
   
    mail(to: email, subject: "測試Email") do |format|
      format.text
      format.html
    end
  end
end
