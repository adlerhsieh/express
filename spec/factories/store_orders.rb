FactoryGirl.define do
  factory :store_order, :class => 'Store::Order' do
    id 1
    price 1
    paid false
    token "MyString"
    payment_method_id 1
    pay_time Time.now
    shipping_time Time.now
    user_id 1
  end

end
