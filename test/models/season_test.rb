require "test_helper"

class SeasonTest < ActiveSupport::TestCase
  setup do
    @produce = produces :apple
    @apples_in_poland = seasons :apples_in_poland
    @apples_in_mumbai = seasons :apples_in_mumbai
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

  test "only start_time negative is invalid" do
    @apples_in_poland.start_time = -1
    assert_not @apples_in_poland.valid?
  end

  test "only end_time negative is invalid" do
    @apples_in_poland.end_time = -1
    assert_not @apples_in_poland.valid?
  end

  test "start_time and end_time have invalid negative values" do
    @apples_in_poland.start_time = -4
    @apples_in_poland.end_time = -4
    assert_not @apples_in_poland.valid?
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

  # ripe?
  test 'stradle season, ripe' do
    travel_to Time.zone.local(2000, 12, 25) do
      assert @apples_in_mumbai.ripe?
    end
    travel_to Time.zone.local(2000, 02, 5) do
      assert @apples_in_mumbai.ripe?
    end
  end

  test 'stradle season, unripe' do
    travel_to Time.zone.local(2000, 6, 4) do
      assert_not @apples_in_mumbai.ripe?
    end
  end

  test 'solid season, ripe' do
    travel_to Time.zone.local(2000, 8, 5) do
      assert @apples_in_poland.ripe?
    end
  end

  test 'solid season, unripe' do
    travel_to Time.zone.local(2000, 2, 18) do
      assert_not @apples_in_poland.ripe?
    end
    travel_to Time.zone.local(2000, 11, 22) do
      assert_not @apples_in_poland.ripe?
    end
  end
end
