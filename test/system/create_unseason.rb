require "application_system_test_case"
require 'minitest/autorun'

class SeasonsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:john)
  end

  test 'create an unseason' do
    visit produce_url(produces :no_season)
    assert_selector "h1", text: "Plum"
    assert_selector "#no-season-title"
    find("#no-season").click
    assert_selector "h1", text: "Plum"
    assert_text "This produce was declared to have no season"
  end
end
