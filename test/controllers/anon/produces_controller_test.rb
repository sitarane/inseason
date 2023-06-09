require "test_helper"

class AnonProducesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @produce = produces :apple
    @user = users :john
  end

  test "should get index" do
    get produces_url
    assert_response :success
    assert_select 'span', 'in New York, United States.'
  end

  test "should not get new" do
    get new_produce_url
    assert_redirected_to new_user_session_path
  end

  test "unable to create produce" do
    assert_no_difference("Produce.count") do
      post produces_url, params: { produce: { name: @produce.name, user_id: @user.id } }
    end

    assert_redirected_to new_user_session_path
  end

  test "should show produce" do
    get produce_url(@produce)
    assert_response :success
    assert_select 'h1', @produce.name
    # shows nearest season
    assert_select "div#season_#{seasons(:apples_in_newyork).id}"
  end

  test 'produce action buttons not visible' do
    get produce_url(@produce)
    assert_select 'h1', @produce.name
    assert_select 'div#produce-actions a', false
  end

  test "should get edit" do
    get edit_produce_url(@produce)
    assert_redirected_to new_user_session_path
  end

  test "should not update produce" do
    new_name = 'New name'
    patch produce_url(@produce), params: { produce: { name: new_name } }
    @produce.reload
    assert_not_equal new_name, @produce.name
    assert_redirected_to new_user_session_path
  end

  test "should not destroy produce" do
    assert_no_difference("Produce.count", -1) do
      delete produce_url(@produce)
    end

    assert_redirected_to new_user_session_path
  end
end
