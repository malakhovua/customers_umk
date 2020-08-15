require "application_system_test_case"

class PricetypesTest < ApplicationSystemTestCase
  setup do
    @pricetype = pricetypes(:one)
  end

  test "visiting the index" do
    visit pricetypes_url
    assert_selector "h1", text: "Pricetypes"
  end

  test "creating a Pricetype" do
    visit pricetypes_url
    click_on "New Pricetype"

    fill_in "Name", with: @pricetype.name
    click_on "Create Pricetype"

    assert_text "Pricetype was successfully created"
    click_on "Back"
  end

  test "updating a Pricetype" do
    visit pricetypes_url
    click_on "Edit", match: :first

    fill_in "Name", with: @pricetype.name
    click_on "Update Pricetype"

    assert_text "Pricetype was successfully updated"
    click_on "Back"
  end

  test "destroying a Pricetype" do
    visit pricetypes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Pricetype was successfully destroyed"
  end
end
