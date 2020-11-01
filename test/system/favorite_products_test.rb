require "application_system_test_case"

class FavoriteProductsTest < ApplicationSystemTestCase
  setup do
    @favorite_product = favorite_products(:one)
  end

  test "visiting the index" do
    visit favorite_products_url
    assert_selector "h1", text: "Favorite Products"
  end

  test "creating a Favorite product" do
    visit favorite_products_url
    click_on "New Favorite Product"

    fill_in "Product", with: @favorite_product.product_id
    fill_in "User", with: @favorite_product.user_id
    click_on "Create Favorite product"

    assert_text "Favorite product was successfully created"
    click_on "Back"
  end

  test "updating a Favorite product" do
    visit favorite_products_url
    click_on "Edit", match: :first

    fill_in "Product", with: @favorite_product.product_id
    fill_in "User", with: @favorite_product.user_id
    click_on "Update Favorite product"

    assert_text "Favorite product was successfully updated"
    click_on "Back"
  end

  test "destroying a Favorite product" do
    visit favorite_products_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Favorite product was successfully destroyed"
  end
end
