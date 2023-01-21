FactoryBot.define do
  factory :transaction do
    name { "Transaction 1" }
    description { "Transaction 1 description" }
    value { 10.5 }
    date { "2022-11-08" }
    category { nil }
    subcategory { nil }
    account { nil }
  end

  factory :category do
    name { 'Category 1' }
    description { 'Category 1 description' }
    user { nil }
    subcategory { nil }
  end

  factory :subcategory do
    name { 'Subcategory 1' }
    description { 'Subcategory 1 description' }
    user { nil }
    subcategory { nil }
  end

  factory(:user) do
    first_name { 'Sample' }
    last_name { 'User' }
    email { 'user@email.com' }
    password { 'password' }
  end

  factory(:account) do
    name { 'Account 1' }
    description { 'Account 1 description' }
    initial_amount { 0 }
  end
end