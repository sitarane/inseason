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
    click_on "Add season"
    select 'Early February', from: 'Start time'
    select 'Late March', from: 'End time'y
    click_on "Create Season"
    assert_text "Season was successfully created."
    assert_selector 'div#in-season'
  end
end
