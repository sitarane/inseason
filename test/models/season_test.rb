require "test_helper"

class SeasonTest < ActiveSupport::TestCase
  setup do
    @produce = produces :apple
    @apples_in_poland = seasons :apples_in_poland
    @user = users(:john)
  end

  test 'good season is valid' do
    season = @produce.seasons.new(latitude: 12.5658, longitude: -15.5658, start_time: 6, end_time: 23, user: @user)
    assert season.valid?
  end

  test 'missing attibutes are invalid' do
    season_1 = @produce.seasons.new(start_time: 6.5658, end_time: 23.5658, user: @user)
    assert_not season_1.valid?
    season_2 = @produce.seasons.new(latitude: 12.5658, longitude: -15.5658, user: @user)
    assert_not season_2.valid?
  end

  test 'no user is invalid' do
    season = @produce.seasons.new(latitude: 12.5658, longitude: -15.5658, start_time: 6, end_time: 23)
    assert_not season.valid?
  end

  test 'invalid coordinates' do
    valid_season = @produce.seasons.new(latitude: 78.5658, longitude: -163.5658, start_time: 6, end_time: 23, user: @user)
    assert valid_season.valid?
    invalid_season = @produce.seasons.new(latitude: -163.5658, longitude: 78.5658, start_time: 6, end_time: 23, user: @user)
    assert_not invalid_season.valid?
  end

  test '#score' do
    assert @apples_in_poland.vouches.upvoted.count == 9
    assert @apples_in_poland.vouches.downvoted.count == 2
    assert @apples_in_poland.score == 7
  end

  test '#confirmed' do
    assert @apples_in_poland.confirmed?
    assert_not seasons(:apples_in_mumbai).confirmed?
  end
end
