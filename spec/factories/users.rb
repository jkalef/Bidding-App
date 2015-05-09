FactoryGirl.define do
  factory :user do
    username Faker::Name::first_name
    password Faker::Internet.password(12)
    sequence(:email) {|n| "my_email_#{n}@gmail.com"}
  end
end
