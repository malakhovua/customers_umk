require "application_system_test_case"

class PacksTest < ApplicationSystemTestCase
  setup do
    @pack = packs(:one)
  end

  test "visiting the index" do
    visit packs_url
    assert_selector "h1", text: "Packs"
  end

  test "creating a Pack" do
    visit packs_url
    click_on "New Pack"

    fill_in "Description", with: @pack.description
    fill_in "Name", with: @pack.name
    click_on "Create Pack"

    assert_text "Pack was successfully created"
    click_on "Back"
  end

  test "updating a Pack" do
    visit packs_url
    click_on "Edit", match: :first

    fill_in "Description", with: @pack.description
    fill_in "Name", with: @pack.name
    click_on "Update Pack"

    assert_text "Pack was successfully updated"
    click_on "Back"
  end

  test "destroying a Pack" do
    visit packs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Pack was successfully destroyed"
  end
end
