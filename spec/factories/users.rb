# DHP-50
FactoryBot.define do
  factory :user_account do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birth_date { Faker::Date.birthday }
    phone_number { '555000111' }
    email { Faker::Internet.email }
    active { true }
    locked { false }
    username { Faker::Internet.username }
  end
end
