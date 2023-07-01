require "test_helper"

class VouchTest < ActiveSupport::TestCase
  setup do
    @john = users(:john)
    @alice = users :alice
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

  test 'delete season when third downvote' do
    assert_difference 'Season.count', -1 do
      @season.vouches.create(user: @john, value: false)
    end
  end

  test 'dont delete season when second downvote' do
    @season.vouches.create(user: @john, value: true)
    assert_equal -1, @season.score
    assert_no_difference 'Season.count' do
      @season.vouches.create(user: @alice, value: false)
    end
  end
end
