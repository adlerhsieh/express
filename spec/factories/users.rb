FactoryGirl.define do
  factory :user do
    id 1
    name "adler"
    email "hello@gmail.com"
    is_admin true
    password "hello_world"
    password_confirmation "hello_world"
  end
end
