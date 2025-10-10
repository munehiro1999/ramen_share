FactoryBot.define do
  factory :like do
    association :user
    association :ramen_post
  end
end
