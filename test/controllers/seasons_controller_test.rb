require "test_helper"

class SeasonsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:john)
    @produce = produces(:apple)
    @season = @produce.seasons.first
  end

  # test 'Produce view shows seasons'

  test "should get new" do
    get new_produce_season_url(@produce)
    assert_response :success
  end

  test "should create season" do
    assert_difference("Season.count") do
      post produce_seasons_url(@produce), params: { season: { end_time: @season.end_time, latitude: @season.latitude, longitude: @season.longitude, produce_id: @season.produce_id, start_time: @season.start_time } }
    end

    assert_redirected_to produces_url(@produce)
  end

  # test "should show season" do
  #   get season_url(@season)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_season_url(@season)
  #   assert_response :success
  # end
  #
  # test "should update season" do
  #   patch produce_season_url(@produce, @season), params: { season: { end_time: @season.end_time, latitude: @season.latitude, longitude: @season.longitude, produce_id: @season.produce_id, start_time: @season.start_time } }
  #   assert_redirected_to season_url(@season)
  # end

  # test "should destroy season" do
  #   assert_difference("Season.count", -1) do
  #     delete season_url(@season)
  #   end
  #
  #   assert_redirected_to seasons_url
  # end
end
