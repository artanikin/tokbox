FactoryGirl.define do
  factory :message do
    session_user_id 1
    room_id 1
    text "MyString"
  end
end
