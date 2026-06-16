FactoryBot.define do
  factory :comment do
    post { nil }
    body { "MyText" }
    user { "MyString" }
  end
end
