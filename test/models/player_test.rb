require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  def setup
    @player = Player.new(first: "Blake", last: "Borderman", importid: "bordbl01")
  end

  test "should be valid" do
    assert @player.valid?
  end
end
