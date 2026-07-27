require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @new_user = create(:user)
  end

  # Karma State

  test "#karma is zero for new users" do
    assert_equal 0, @new_user.karma
  end

  # Multiplier

  test 'multiplier is 1 for users with no karma' do
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
