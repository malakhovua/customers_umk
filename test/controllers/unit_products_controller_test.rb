require 'test_helper'

class UnitProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @unit_product = unit_products(:one)
  end

  test "should get index" do
    get unit_products_url
    assert_response :success
  end

  test "should get new" do
    get new_unit_product_url
    assert_response :success
  end

  test "should create unit_product" do
    assert_difference('UnitProduct.count') do
      post unit_products_url, params: { unit_product: { default: @unit_product.default, name: @unit_product.name, product: @unit_product.product } }
    end

    assert_redirected_to unit_product_url(UnitProduct.last)
  end

  test "should show unit_product" do
    get unit_product_url(@unit_product)
    assert_response :success
  end

  test "should get edit" do
    get edit_unit_product_url(@unit_product)
    assert_response :success
  end

  test "should update unit_product" do
    patch unit_product_url(@unit_product), params: { unit_product: { default: @unit_product.default, name: @unit_product.name, product: @unit_product.product } }
    assert_redirected_to unit_product_url(@unit_product)
  end

  test "should destroy unit_product" do
    assert_difference('UnitProduct.count', -1) do
      delete unit_product_url(@unit_product)
    end

    assert_redirected_to unit_products_url
  end
end
