require 'test_helper'

class PricetypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pricetype = pricetypes(:one)
  end

  test "should get index" do
    get pricetypes_url
    assert_response :success
  end

  test "should get new" do
    get new_pricetype_url
    assert_response :success
  end

  test "should create pricetype" do
    assert_difference('Pricetype.count') do
      post pricetypes_url, params: { pricetype: { name: @pricetype.name } }
    end

    assert_redirected_to pricetype_url(Pricetype.last)
  end

  test "should show pricetype" do
    get pricetype_url(@pricetype)
    assert_response :success
  end

  test "should get edit" do
    get edit_pricetype_url(@pricetype)
    assert_response :success
  end

  test "should update pricetype" do
    patch pricetype_url(@pricetype), params: { pricetype: { name: @pricetype.name } }
    assert_redirected_to pricetype_url(@pricetype)
  end

  test "should destroy pricetype" do
    assert_difference('Pricetype.count', -1) do
      delete pricetype_url(@pricetype)
    end

    assert_redirected_to pricetypes_url
  end
end
