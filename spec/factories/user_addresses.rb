FactoryGirl.define do
  factory :user_address, :class => 'User::Address' do
    address "MyString"
phone "MyString"
user_id 1
  end

end
