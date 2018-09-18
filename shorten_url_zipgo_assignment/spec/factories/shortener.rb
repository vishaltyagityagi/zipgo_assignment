FactoryGirl.define do
  factory :shortener do
    url { Faker::Internet.url}
  end
end
