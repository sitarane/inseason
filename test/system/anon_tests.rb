require "application_system_test_case"

class AnonTests < ApplicationSystemTestCase
  test "Basic navigation" do
    visit root_url
    assert_selector "h1", text: "Produces"
    assert_selector "h2", text: "Apple"
    assert_selector "h2", text: "Carrot"
    click_on "Apple"
    assert_selector "h1", text: "Apple"
    click_on "Back to produces"
    assert_selector "h1", text: "Produces"
    assert_selector "h2", text: "Carrot"
    click_on "Carrot"
    assert_selector "h1", text: "Carrot"
  end
end
