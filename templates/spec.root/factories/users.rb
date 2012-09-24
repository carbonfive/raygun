FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    name             'Tom Middleton'
    password         'password'
  end
end
