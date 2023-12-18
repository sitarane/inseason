require "application_system_test_case"
require 'minitest/autorun'

class SeasonsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:alice)
  end

  test 'create a produce and a season' do
    visit root_url
    fill_in "query", with: "Space beetroot"
    click_on "Search"
    assert_text "We don't have a produce called Space beetroot."
    assert_link "create it"
    Wikipedia::Client.stub :new, fake_wiki_client do
      click_on "create it"
    end
    assert_selector "h1", text: "New produce"
    Wikipedia::Client.stub :new, fake_wiki_client do
      click_on "Create Produce"
    end
    assert_text "Produce was successfully created."
    assert_selector "h1", text: "Space beetroot"
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
