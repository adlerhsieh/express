FactoryGirl.define do
  factory :store_order_item, :class => 'Store::OrderItem' do
    quantity 1
price 1
order_id 1
product_id 1
  end

end
