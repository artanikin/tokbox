class SessionUser < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates :room_id, :user_id, :token, :role, presence: true
  validates :role, inclusion: { in: %w(subscriber publisher moderator) }
end
