# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "MyString"
    email "anemail@example.com"
    # password_digest "foobar"
    password "foobar"
    password_confirmation "foobar"
    # remember_token "MyString"
  end
end
