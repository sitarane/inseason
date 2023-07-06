require "application_system_test_case"

class AnonTests < ApplicationSystemTestCase
  test "Basic navigation" do
    travel_to Time.zone.local(2000, 7, 6) do
      visit root_url
      assert_selector "h1", text: "In season now"
      assert_selector "h2", text: "Apple"
      click_on "Apple"
      assert_selector "h1", text: "Apple"
      click_on "Back to produces"
      assert_selector "h1", text: "In season now"
      assert_selector "h2", text: "Apple"
    end
  end
end
