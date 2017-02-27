require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:session_users) }
  it { should have_many(:rooms).through(:session_users) }

  describe "#has_session?" do
    let(:user) { create(:user) }
    let(:room) { create(:room) } 

    it "has session" do
      create(:session_user, room: room, user: user)
      expect(user.has_session?(room.id)).to be_truthy
    end

    it "has not session" do
      expect(user.has_session?(room.id)).to be_falsey
    end
  end

  describe "#session" do
    let(:user) { create(:user) }
    let(:room) { create(:room) } 

    it "get user session for the room" do
      session_user = create(:session_user, room: room, user: user)
      expect(user.session(room.id)).to eq(session_user)
    end
  end
end
