require "rails_helper"

RSpec.describe OrderMailer, type: :mailer do
  before { create_factory }
  describe "notify_paid" do
    let(:mail) { OrderMailer.notify_paid(Store::Order.first) }

    it "renders the headers" do
      expect(mail.subject).to include("付款成功通知")
      expect(mail.to).to eq(["hello@gmail.com"])
    end

    it "renders the body" do
      expect{ mail.body.encoded }.not_to raise_error
    end
  end

  describe "notify_shipped" do
    let(:mail) { OrderMailer.notify_shipped(Store::Order.first) }

    it "renders the headers" do
      expect(mail.subject).to include("出貨通知")
      expect(mail.to).to eq(["hello@gmail.com"])
    end

    it "renders the body" do
      expect{ mail.body.encoded }.not_to raise_error
    end
  end

end
