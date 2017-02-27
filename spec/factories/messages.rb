FactoryGirl.define do
  factory :message do
    session_user
    room
    text "test chat message"
  end
end
