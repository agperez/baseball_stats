require 'rails_helper'

RSpec.describe Player, :type => :model do
  it "is invalid without an importid" do
    player = Player.new(first: "Joe", last: "Blanton")
    expect(player).not_to be_valid
  end
end
