require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @new_user = create(:user)
  end

  # Karma

  test "#karma is zero for new users" do
    assert_equal 0, @new_user.karma
  end

  test "#karma gets incremented if you voted for a season that is confirmed" do
    season = create(:season)
    create(:vouch, user: @new_user, season: season)
    @new_user.reload
    assert_equal 0, @new_user.karma
    create_list(:vouch, 10, season: season) # make it confirmed
    @new_user.reload
    assert_equal 1, @new_user.karma
  end

  test "#karma gets decremented if you voted against a confirmed season" do
    season = create(:season)
    create(:vouch, value: false, user: @new_user, season: season)
    @new_user.reload
    assert_equal 0, @new_user.karma
    create_list(:vouch, 12, season: season) # make it confirmed
    @new_user.reload
    assert_equal -1, @new_user.karma
  end

  test "If you downvoted a season that gets deleted, +1" do
    season = create(:season)
    Vouch.create(value: false, user: @new_user, season: season)
    season.destroy
    @new_user.reload
    assert_equal 1, @new_user.karma
  end

  test "If you upvoted a season that gets deleted -1" do
    season = create(:season)
    Vouch.create(value: true, user: @new_user, season: season)
    season.destroy
    assert_equal -1, @new_user.karma
  end

  test "+3 if a season you created gets confirmed" do
    season = create(:season, :confirmed, user: @new_user)
    assert_equal 3, @new_user.karma
  end

  test "-3 if a season you created gets deleted" do
    season = create(:season, user: @new_user)
    season.destroy
    assert_equal -3, @new_user.karma
  end

  test "+1 per season for a produce you created" do
    produce = create(:produce, user: @new_user)
    @new_user.reload
    assert_equal 0, @new_user.karma
    season = create(:season, produce: produce)
    @new_user.reload
    assert_equal 1, @new_user.karma
  end

  test "-1 for produce that get deleted" do
    produce = create(:produce)
    user = produce.user
    assert_equal 0, user.karma
    produce.destroy
    user.reload
    assert_equal -1, user.karma
  end

  # Mutiplier

  test 'mulitplier is 1 for users with no karma' do
    assert_equal 0, @new_user.karma
    assert_equal 1, @new_user.multiplier
  end

    test 'multiplier is around 2 for a karma of 10' do
    @new_user.stub :karma, 10 do
      assert_in_delta 2.0, @new_user.multiplier, 0.5
    end
  end

  test 'multiplier is around 0.5 for a karma of -10' do
    @new_user.stub :karma, -10 do
      assert_in_delta 0.5, @new_user.multiplier, 0.2
    end
  end

  test 'multiplier cant be higher than 3' do
    @new_user.stub :karma, 9999 do
      assert @new_user.multiplier <= 3
    end
  end

  test 'multiplier cant be lower than 0.34' do
    @new_user.stub :karma, -9999 do
      assert @new_user.multiplier >= 1/3
    end
  end
end
