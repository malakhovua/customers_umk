require "application_system_test_case"

class InventoriesTest < ApplicationSystemTestCase
  setup do
    @inventory = inventories(:one)
  end

  test "visiting the index" do
    visit inventories_url
    assert_selector "h1", text: "Inventories"
  end

  test "creating a Inventory" do
    visit inventories_url
    click_on "New Inventory"

    fill_in "Date", with: @inventory.date
    fill_in "Desc", with: @inventory.desc
    fill_in "Storage places", with: @inventory.storage_places_id
    fill_in "User", with: @inventory.user_id
    click_on "Create Inventory"

    assert_text "Inventory was successfully created"
    click_on "Back"
  end

  test "updating a Inventory" do
    visit inventories_url
    click_on "Edit", match: :first

    fill_in "Date", with: @inventory.date
    fill_in "Desc", with: @inventory.desc
    fill_in "Storage places", with: @inventory.storage_places_id
    fill_in "User", with: @inventory.user_id
    click_on "Update Inventory"

    assert_text "Inventory was successfully updated"
    click_on "Back"
  end

  test "destroying a Inventory" do
    visit inventories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Inventory was successfully destroyed"
  end
end
