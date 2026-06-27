require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @new_user = create(:user)
    @season = seasons(:apples_in_mumbai)
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
    Vouch.create(value: true, user: @new_user, season: @season)
    @season.stub :confirmed?, true do
      debugger
      assert_equal 1, @new_user.karma
    end
  end

  test "#karma gets decremented if you voted against a confirmed season" do
    Vouch.create(value: false, user: @new_user, season: @season)
    @season.stub :confirmed?, true do
      assert_equal -1, @new_user.karma
    end
  end

  test "If you downvoted a season that gets deleted, +1" do
    Vouch.create(value: false, user: @new_user, season: @season)
    @season.destroy
    assert_equal 1, @new_user.karma
  end

  test "If you upvoted a season that gets deleted -1" do
    Vouch.create(value: true, user: @new_user, season: @season)
    @season.destroy
    assert_equal -1, @new_user.karma
  end

  test "+3 if a season you created gets confirmed" do
    assert_equal 3, users(:alice).karma
  end

  test "-3 if a season you created gets deleted" do
    @season.destroy
    assert_equal -3, users(:alice).karma
  end

  test "+1 per season for a produce you created" do
    assert_equal 2, users(:john).karma
  end

  test "-1 for produce that get deleted" do
    assert false
  end


end
