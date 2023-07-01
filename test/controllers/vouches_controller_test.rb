require "test_helper"

class VouchesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users :john
    @produce = produces :apple
    @alices_season = seasons :apples_in_mumbai
    @johns_season = seasons :apples_in_newyork
    @vouch = vouches :john_in_poland
    sign_in @user
  end

  test 'can vote' do
    assert_difference("Vouch.count") do
      post produce_vouches_path(@produce), params: { vouch: { value: true, user_id: @user.id, season_id: @alices_season.id }}
    end
  end

  test 'unable to vote on season you created' do
    assert_raise Pundit::NotAuthorizedError do
      post produce_vouches_path(@produce), params: { vouch: { value: false, user_id: @user.id, season_id: @johns_season.id }}
    end
  end

  test 'can change vote' do
    assert @vouch.value
    patch vouch_path(@vouch), params: { vouch: { value: false }}
    assert_not @vouch.reload.value
  end
end
