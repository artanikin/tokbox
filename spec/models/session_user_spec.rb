require 'rails_helper'

RSpec.describe SessionUser, type: :model do
  it { should belong_to(:room) }
  it { should belong_to(:user) }
  it { should have_many(:messages) }

  it { should validate_presence_of(:room_id) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:token) }
  it { should validate_inclusion_of(:role).in_array(%w(subscriber publisher moderator)) }
end
