require "rails_helper"

RSpec.describe OrderMailer, type: :mailer do
  describe "notify_paid" do
    let(:mail) { OrderMailer.notify_paid }

    it "renders the headers" do
      expect(mail.subject).to eq("Notify paid")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "notify_shipped" do
    let(:mail) { OrderMailer.notify_shipped }

    it "renders the headers" do
      expect(mail.subject).to eq("Notify shipped")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
