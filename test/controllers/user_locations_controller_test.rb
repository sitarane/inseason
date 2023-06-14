require "test_helper"

class UserLocationsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get edit_user_location_url
    assert_response :success
  end
end
