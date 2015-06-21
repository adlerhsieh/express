FactoryGirl.define do
  factory :store_product, :class => 'Store::Product' do
    title "MyString"
description "MyString"
stock 1
price 1
default_image "MyString"
category_id 1
  end

end
