require "application_system_test_case"

class StoragePlacesTest < ApplicationSystemTestCase
  setup do
    @storage_place = storage_places(:one)
  end

  test "visiting the index" do
    visit storage_places_url
    assert_selector "h1", text: "Storage Places"
  end

  test "creating a Storage place" do
    visit storage_places_url
    click_on "New Storage Place"

    click_on "Create Storage place"

    assert_text "Storage place was successfully created"
    click_on "Back"
  end

  test "updating a Storage place" do
    visit storage_places_url
    click_on "Edit", match: :first

    click_on "Update Storage place"

    assert_text "Storage place was successfully updated"
    click_on "Back"
  end

  test "destroying a Storage place" do
    visit storage_places_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Storage place was successfully destroyed"
  end
end
