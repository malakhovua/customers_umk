require "application_system_test_case"

class ProductExeptionsTest < ApplicationSystemTestCase
  setup do
    @product_exeption = product_exeptions(:one)
  end

  test "visiting the index" do
    visit product_exeptions_url
    assert_selector "h1", text: "Product Exeptions"
  end

  test "creating a Product exeption" do
    visit product_exeptions_url
    click_on "New Product Exeption"

    fill_in "Clients", with: @product_exeption.clients_id
    fill_in "Products", with: @product_exeption.products_id
    click_on "Create Product exeption"

    assert_text "Product exeption was successfully created"
    click_on "Back"
  end

  test "updating a Product exeption" do
    visit product_exeptions_url
    click_on "Edit", match: :first

    fill_in "Clients", with: @product_exeption.clients_id
    fill_in "Products", with: @product_exeption.products_id
    click_on "Update Product exeption"

    assert_text "Product exeption was successfully updated"
    click_on "Back"
  end

  test "destroying a Product exeption" do
    visit product_exeptions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Product exeption was successfully destroyed"
  end
end
