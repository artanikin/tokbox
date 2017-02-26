class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable

  has_many :session_users
  has_many :rooms, through: :session_users

  def has_session?(room_id)
    rooms.map(&:id).include?(room_id)
  end

  def session(room_id)
    session_users.where("room_id = #{room_id}").first
  end
end
