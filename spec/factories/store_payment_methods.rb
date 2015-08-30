FactoryGirl.define do
  factory :store_payment_method, :class => 'Store::PaymentMethod' do
    id 1
    name "paypal"
  end

end
