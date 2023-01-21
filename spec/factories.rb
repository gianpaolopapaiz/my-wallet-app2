FactoryBot.define do
  factory :transaction do
    title { "Transaction 1" }
    description { "Transaction 1 description" }
    amount { 10.5 }
    date { "2022-11-08" }
    category { nil }
    account { nil }
  end

  factory :category do
    name { 'Category 1' }
    description { 'Category 1 description' }
  end

  factory(:user) do
    name { 'Sample User' }
    email { 'user@email.com' }
    password { 'password' }
  end

  factory(:account) do
    name { 'Account 1' }
    description { 'Account 1 description' }
  end
end