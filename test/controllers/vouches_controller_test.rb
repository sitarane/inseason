require "test_helper"

class VouchesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get vouches_create_url
    assert_response :success
  end
end
