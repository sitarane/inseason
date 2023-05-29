require "application_system_test_case"

class ProducesTest < ApplicationSystemTestCase
  setup do
    @produce = produces(:apple)
  end

  test "visiting the index" do
    visit produces_url
    assert_selector "h1", text: "Produces"
  end

  test "should create produce" do
    visit produces_url
    click_on "New produce"

    fill_in "Name", with: @produce.name
    click_on "Create Produce"

    assert_text "Produce was successfully created"
    click_on "Back"
  end

  test "should update Produce" do
    visit produce_url(@produce)
    click_on "Edit this produce", match: :first

    fill_in "Name", with: @produce.name
    click_on "Update Produce"

    assert_text "Produce was successfully updated"
    click_on "Back"
  end

  test "should destroy Produce" do
    visit produce_url(@produce)
    click_on "Destroy this produce", match: :first

    assert_text "Produce was successfully destroyed"
  end
end
