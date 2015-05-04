FactoryGirl.define do
  factory :user do
    name "adler"
    email "hello@gmail.com"
    is_admin true
    password "hello_world"
    password_confirmation "hello_world"
  end
end
