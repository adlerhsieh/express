FactoryGirl.define do
  factory :post do
    title "public post title"
    content "content"
    slug "post_route"
    is_public true

    trait :private do
      title "private post title"
      is_public false
    end
  end
end
