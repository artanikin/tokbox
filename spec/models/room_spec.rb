require 'rails_helper'

RSpec.describe Room, type: :model do
  it { should have_many(:session_users) }
  it { should have_many(:users).through(:session_users) }
  it { should have_many(:messages) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:session_id) }
end
