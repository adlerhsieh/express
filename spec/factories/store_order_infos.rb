FactoryGirl.define do
  factory :store_order_info, :class => 'Store::OrderInfo' do
    shipping_name "MyString"
shipping_address "MyString"
order_id 1
  end

end
