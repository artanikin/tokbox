class Message < ApplicationRecord
  belongs_to :session_user
  belongs_to :room
end
