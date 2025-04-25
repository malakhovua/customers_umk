require 'test_helper'

class InventoryLineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @inventory_line_item = inventory_line_items(:one)
  end

  test "should get index" do
    get inventory_line_items_url
    assert_response :success
  end

  test "should get new" do
    get new_inventory_line_item_url
    assert_response :success
  end

  test "should create inventory_line_item" do
    assert_difference('InventoryLineItem.count') do
      post inventory_line_items_url, params: { inventory_line_item: { inventory_id: @inventory_line_item.inventory_id, price: @inventory_line_item.price, product_id: @inventory_line_item.product_id, qty: @inventory_line_item.qty, sum: @inventory_line_item.sum } }
    end

    assert_redirected_to inventory_line_item_url(InventoryLineItem.last)
  end

  test "should show inventory_line_item" do
    get inventory_line_item_url(@inventory_line_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_inventory_line_item_url(@inventory_line_item)
    assert_response :success
  end

  test "should update inventory_line_item" do
    patch inventory_line_item_url(@inventory_line_item), params: { inventory_line_item: { inventory_id: @inventory_line_item.inventory_id, price: @inventory_line_item.price, product_id: @inventory_line_item.product_id, qty: @inventory_line_item.qty, sum: @inventory_line_item.sum } }
    assert_redirected_to inventory_line_item_url(@inventory_line_item)
  end

  test "should destroy inventory_line_item" do
    assert_difference('InventoryLineItem.count', -1) do
      delete inventory_line_item_url(@inventory_line_item)
    end

    assert_redirected_to inventory_line_items_url
  end
end
