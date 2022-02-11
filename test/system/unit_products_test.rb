require "application_system_test_case"

class UnitProductsTest < ApplicationSystemTestCase
  setup do
    @unit_product = unit_products(:one)
  end

  test "visiting the index" do
    visit unit_products_url
    assert_selector "h1", text: "Unit Products"
  end

  test "creating a Unit product" do
    visit unit_products_url
    click_on "New Unit Product"

    check "Default" if @unit_product.default
    fill_in "Name", with: @unit_product.name
    fill_in "Product", with: @unit_product.product
    click_on "Create Unit product"

    assert_text "Unit product was successfully created"
    click_on "Back"
  end

  test "updating a Unit product" do
    visit unit_products_url
    click_on "Edit", match: :first

    check "Default" if @unit_product.default
    fill_in "Name", with: @unit_product.name
    fill_in "Product", with: @unit_product.product
    click_on "Update Unit product"

    assert_text "Unit product was successfully updated"
    click_on "Back"
  end

  test "destroying a Unit product" do
    visit unit_products_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Unit product was successfully destroyed"
  end
end
