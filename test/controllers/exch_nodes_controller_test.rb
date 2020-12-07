require 'test_helper'

class ExchNodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @exch_node = exch_nodes(:one)
  end

  test "should get index" do
    get exch_nodes_url
    assert_response :success
  end

  test "should get new" do
    get new_exch_node_url
    assert_response :success
  end

  test "should create exch_node" do
    assert_difference('ExchNode.count') do
      post exch_nodes_url, params: { exch_node: { cat: @exch_node.cat, node: @exch_node.node, ser: @exch_node.ser } }
    end

    assert_redirected_to exch_node_url(ExchNode.last)
  end

  test "should show exch_node" do
    get exch_node_url(@exch_node)
    assert_response :success
  end

  test "should get edit" do
    get edit_exch_node_url(@exch_node)
    assert_response :success
  end

  test "should update exch_node" do
    patch exch_node_url(@exch_node), params: { exch_node: { cat: @exch_node.cat, node: @exch_node.node, ser: @exch_node.ser } }
    assert_redirected_to exch_node_url(@exch_node)
  end

  test "should destroy exch_node" do
    assert_difference('ExchNode.count', -1) do
      delete exch_node_url(@exch_node)
    end

    assert_redirected_to exch_nodes_url
  end
end
