require "application_system_test_case"

class SeasonsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:john)
  end

  test 'create a produce and a season' do
    visit root_url
    click_on 'Add produce'
    fill_in "Name", with: "Space beetroots"
    fill_in "Wikipedia link", with: "https://en.wikipedia.org/wiki/Spacebeets"
    click_on "Create Produce"
    assert_text "Produce was successfully created."
    assert_selector "h1", text: "Space beetroots"
    select 'Early February', from: 'Start time'
    select 'Late March', from: 'End time'
    click_on "Create Season"
    assert_selector 'div#in-season'
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
