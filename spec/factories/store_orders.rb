FactoryGirl.define do
  factory :store_order, :class => 'Store::Order' do
    price 1
paid false
token "MyString"
payment_method_id 1
aasm_state "MyString"
  end

end
