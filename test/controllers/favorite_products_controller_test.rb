require 'test_helper'

class FavoriteProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @favorite_product = favorite_products(:one)
  end

  test "should get index" do
    get favorite_products_url
    assert_response :success
  end

  test "should get new" do
    get new_favorite_product_url
    assert_response :success
  end

  test "should create favorite_product" do
    assert_difference('FavoriteProduct.count') do
      post favorite_products_url, params: { favorite_product: { product_id: @favorite_product.product_id, user_id: @favorite_product.user_id } }
    end

    assert_redirected_to favorite_product_url(FavoriteProduct.last)
  end

  test "should show favorite_product" do
    get favorite_product_url(@favorite_product)
    assert_response :success
  end

  test "should get edit" do
    get edit_favorite_product_url(@favorite_product)
    assert_response :success
  end

  test "should update favorite_product" do
    patch favorite_product_url(@favorite_product), params: { favorite_product: { product_id: @favorite_product.product_id, user_id: @favorite_product.user_id } }
    assert_redirected_to favorite_product_url(@favorite_product)
  end

  test "should destroy favorite_product" do
    assert_difference('FavoriteProduct.count', -1) do
      delete favorite_product_url(@favorite_product)
    end

    assert_redirected_to favorite_products_url
  end
end
