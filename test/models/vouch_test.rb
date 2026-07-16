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

  # Confirm seasons

  test 'dont confirm season on less than 10 score' do
    season = create(:season, :score_of_5_mixed)
    create(:vouch, season: season)
    assert_not season.confirmed?
  end

  test 'confirm season on more than 10 score' do
    season = create(:season, :score_of_9_mixed)
    create(:vouch, season: season)
    assert season.confirmed?
  end

  test 'unconfirm season when score goes below 10' do
    season = create(:season, :confirmed)
    assert season.confirmed?
    create_list(:vouch, 2, season:season, value: false)
    assert_not season.confirmed?
  end

  # Delete seasons

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
