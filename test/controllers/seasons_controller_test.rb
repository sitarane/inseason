require "test_helper"

class SeasonsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users :john
    @produce = produces :no_season
    @season = seasons :apples_in_poland
  end

  test "should create season" do
    assert_difference("Season.count") do
      post produce_seasons_url(@produce), params: { season: { end_time: @season.end_time, latitude: @season.latitude, longitude: @season.longitude, produce_id: @season.produce_id, start_time: @season.start_time } }
    end

    assert_response :redirect
  end
end
