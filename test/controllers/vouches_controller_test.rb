require "test_helper"

class VouchesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users :john
    @produce = produces :apple
    @season = seasons :apples_in_mumbai
    @vouch = vouches :john_in_poland
    sign_in @user
  end
  test '#create' do
    assert_difference("Vouch.count") do
      post produce_vouches_path(@produce), params: { vouch: { value: false, user_id: @user.id, season_id: @season.id }}
    end
  end
  test '#update' do
    assert @vouch.value
    patch vouch_path(@vouch), params: { vouch: { value: false }}
    assert_not @vouch.reload.value
  end
end
