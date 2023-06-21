require "test_helper"

class VouchTest < ActiveSupport::TestCase
  setup do
    @john = users(:john)
    @season = seasons(:apples_in_mumbai)
  end
  test "must have value" do
    vouch = @season.vouches.new(user: @john)
    assert_not vouch.valid?
  end
  test "valid vouch is valid" do
    vouch = @season.vouches.new(user: @john, value: true)
    assert vouch.valid?
  end
  test '#prefix' do
    assert vouches(:john_in_poland).prefix == 'up'
    assert vouches(:six_in_poland).prefix == 'down'
  end
end
