FactoryGirl.define do
  factory :store_payment_transfer, :class => 'Store::PaymentTransfer' do
    order_id 1
status "MyString"
transaction_id "MyString"
confirm false
confirm_time "2015-06-28 11:37:27"
  end

end
