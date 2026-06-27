require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @new_user = create(:user)
  end

  # Multiplier

  # test "#multiplier should be 1 by default" do
    
  # end

  # test "#multiplier should be less than 3 even for high karma users"
  
  # test "#multiplier should be more than 0.3 for low karma users"

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

  # test "+3 if a season you created gets confirmed" do
  #   # Note: This test relies on fixtures (users(:alice)). 
  #   # Ensure your fixtures are loaded correctly in the test environment.
  #   assert_equal 3, users(:alice).karma
  # end

  # test "-3 if a season you created gets deleted" do
  #   season = create(:season, user: users(:alice))
  #   season.destroy
  #   assert_equal -3, users(:alice).karma
  # end

  # test "+1 per season for a produce you created" do
  #   # Note: This test relies on fixtures (users(:john)).
  #   assert_equal 2, users(:john).karma
  # end

  # test "-1 for produce that get deleted" do
  #   assert false
  # end
end
