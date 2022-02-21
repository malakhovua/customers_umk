require 'test_helper'

class AccessGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @access_group = access_groups(:one)
  end

  test "should get index" do
    get access_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_access_group_url
    assert_response :success
  end

  test "should create access_group" do
    assert_difference('AccessGroup.count') do
      post access_groups_url, params: { access_group: { name: @access_group.name } }
    end

    assert_redirected_to access_group_url(AccessGroup.last)
  end

  test "should show access_group" do
    get access_group_url(@access_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_access_group_url(@access_group)
    assert_response :success
  end

  test "should update access_group" do
    patch access_group_url(@access_group), params: { access_group: { name: @access_group.name } }
    assert_redirected_to access_group_url(@access_group)
  end

  test "should destroy access_group" do
    assert_difference('AccessGroup.count', -1) do
      delete access_group_url(@access_group)
    end

    assert_redirected_to access_groups_url
  end
end
