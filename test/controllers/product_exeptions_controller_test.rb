require 'test_helper'

class ProductExeptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_exeption = product_exeptions(:one)
  end

  test "should get index" do
    get product_exeptions_url
    assert_response :success
  end

  test "should get new" do
    get new_product_exeption_url
    assert_response :success
  end

  test "should create product_exeption" do
    assert_difference('ProductExeption.count') do
      post product_exeptions_url, params: { product_exeption: { clients_id: @product_exeption.clients_id, products_id: @product_exeption.products_id } }
    end

    assert_redirected_to product_exeption_url(ProductExeption.last)
  end

  test "should show product_exeption" do
    get product_exeption_url(@product_exeption)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_exeption_url(@product_exeption)
    assert_response :success
  end

  test "should update product_exeption" do
    patch product_exeption_url(@product_exeption), params: { product_exeption: { clients_id: @product_exeption.clients_id, products_id: @product_exeption.products_id } }
    assert_redirected_to product_exeption_url(@product_exeption)
  end

  test "should destroy product_exeption" do
    assert_difference('ProductExeption.count', -1) do
      delete product_exeption_url(@product_exeption)
    end

    assert_redirected_to product_exeptions_url
  end
end
