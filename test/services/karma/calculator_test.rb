require "test_helper"

class Karma::CalculatorTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
  end

  test "#karma gets incremented if you voted for a season that is confirmed" do
    season = create(:season)
    create(:vouch, user: @user, season: season)
    
    @user.reload
    assert_equal 0, @user.karma
    
    # Make season confirmed
    create_list(:vouch, 10, season: season)
    
    @user.reload
    assert_equal 1, @user.karma
  end

  test "#karma gets decremented if you voted against a confirmed season" do
    season = create :season 
    create(:vouch, value: false, user: @user, season: season)
    
    @user.reload
    assert_equal 0, @user.karma
    
    # Make season confirmed
    create_list(:vouch, 12, season: season)
    
    @user.reload
    assert_equal -1, @user.karma
  end

  test "If you downvoted a season that gets deleted, +1" do
    produce = create(:produce, user: @user)
    season = create(:season, produce: produce)
    create(:vouch, value: false, user: @user, season: season)
    
    season.destroy
    @user.reload
    assert_equal 1, @user.karma
  end

  test "If you upvoted a season that gets deleted -1" do
    season = create :season
    create(:vouch, value: true, user: @user, season: season)
    
    season.destroy
    @user.reload
    assert_equal -1, @user.karma
  end

  test "+3 if a season you created gets confirmed" do
    season = create(:season, :confirmed, user: @user)
    @user.reload
    assert_equal 3, @user.karma
  end

  test "-3 if a season you created gets deleted" do
    season = create(:season, user: @user)
    
    season.destroy
  
    @user.reload
    assert_equal -3, @user.karma
  end

  test "+1 per season for a produce you created" do
    produce = create(:produce, user: @user)
    @user.reload
    assert_equal 0, @user.karma
    create(:season, produce: produce)
    @user.reload
    assert_equal 1, @user.karma
  end

  test "-1 for produce that get deleted" do
    produce = create(:produce)
    user = produce.user
    produce.destroy
    user.reload
    assert_equal -1, user.karma
  end
end
