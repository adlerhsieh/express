FactoryGirl.define do
  factory :store_payment_notification, :class => 'Store::PaymentNotification' do
    params "MyText"
order_id 1
status "MyString"
transaction_id "MyString"
  end

end
