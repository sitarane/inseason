require "test_helper"

class ProducesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:john)
    @produce = produces(:apple)
  end

  test "should get index" do
    get produces_url
    assert_response :success
  end

  test "should get new" do
    get new_produce_url
    assert_response :success
  end

  test "should create produce" do
    assert_difference("Produce.count") do
      post produces_url, params: { produce: { name: @produce.name } }
    end

    assert_redirected_to produce_url(Produce.last)
  end

  test "should create produce with picture" do
    picture = fixture_file_upload('test/fixtures/files/apple.jpg')
    params = {
      produce: {
        name: @produce.name,
        picture: picture
      }
    }
    assert_difference("Produce.count") do
      post produces_url, params: params
    end

    assert_redirected_to produce_url(Produce.last)
  end

  test "should show produce" do
    get produce_url(@produce)
    assert_response :success
  end

  test "should get edit" do
    get edit_produce_url(@produce)
    assert_response :success
  end

  test "should change produce name" do
    new_name = 'New name'
    patch produce_url(@produce), params: { produce: { name: new_name } }
    @produce.reload
    assert_equal new_name, @produce.name
    assert_redirected_to produce_url(@produce)
  end

  test "should add an image to produce" do
    picture = fixture_file_upload('test/fixtures/files/apple.jpg')
    patch produce_url(@produce), params: { produce: { picture: picture } }
    @produce.reload
    assert @produce.picture.attached?
    assert_redirected_to produce_url(@produce)
  end

  test "should destroy produce" do
    assert_difference("Produce.count", -1) do
      delete produce_url(@produce)
    end

    assert_redirected_to produces_url
  end
end