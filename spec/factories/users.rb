# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "MyString"
    email "anemail@example.com"
    password_digest "MyString"
    remember_token "MyString"
  end
end
