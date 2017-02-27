require 'rails_helper'

RSpec.describe Message, type: :model do
  it { should belong_to(:session_user) }
  it { should belong_to(:room) }
end
