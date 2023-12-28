require "application_system_test_case"
require 'minitest/autorun'

class SeasonsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:alice)
  end

  test 'vote on season' do
    visit produce_url produces :apple
    assert_selector 'button', text: 'Upvote'
    assert_selector 'button', text: 'Downvote'
    assert_no_text 'You have upvoted this season.'
    click_on 'Upvote'
    assert_no_selector 'button', text: 'Upvote'
    assert_selector 'button', text: 'Downvote'
    assert_text 'You have upvoted this season.'
  end
end
