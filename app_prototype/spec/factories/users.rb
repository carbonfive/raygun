FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    name             'Tom Middleton'
    password         'password'

    factory :admin do
      name           'Admin'
      admin          true
    end
  end
end
