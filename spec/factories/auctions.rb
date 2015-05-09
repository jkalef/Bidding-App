FactoryGirl.define do
  factory :auction do

    association :user, factory: :user
    title Faker::Company.bs
    details Faker::Lorem.paragraph
    reserved_price 1
    ends_on "2015-07-08 09:39:19"
  end
end
