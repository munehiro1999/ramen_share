FactoryBot.define do
  factory :ramen_post do
    title { "美味しいラーメン" }
    genre { :ramen }
    description { "最高に美味しいラーメンです" }
    rating { 4.5 }
    address { "東京都渋谷区1-1-1" }
    association :user


    after(:build) do |ramen_post|
      ramen_post.images.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/test_image.png")),
        filename: "test_image.png",
        content_type: "image/png"
      )
    end
  end
end
