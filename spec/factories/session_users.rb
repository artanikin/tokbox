FactoryGirl.define do
  sequence :nikname do |n|
    "User#{n}"
  end

  factory :session_user do
    room
    user
    token "MyString"
    nikname
    role "subscriber"
  end
end
