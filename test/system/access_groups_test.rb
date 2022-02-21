require "application_system_test_case"

class AccessGroupsTest < ApplicationSystemTestCase
  setup do
    @access_group = access_groups(:one)
  end

  test "visiting the index" do
    visit access_groups_url
    assert_selector "h1", text: "Access Groups"
  end

  test "creating a Access group" do
    visit access_groups_url
    click_on "New Access Group"

    fill_in "Name", with: @access_group.name
    click_on "Create Access group"

    assert_text "Access group was successfully created"
    click_on "Back"
  end

  test "updating a Access group" do
    visit access_groups_url
    click_on "Edit", match: :first

    fill_in "Name", with: @access_group.name
    click_on "Update Access group"

    assert_text "Access group was successfully updated"
    click_on "Back"
  end

  test "destroying a Access group" do
    visit access_groups_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Access group was successfully destroyed"
  end
end
