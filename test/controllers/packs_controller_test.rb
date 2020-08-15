require 'test_helper'

class PacksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pack = packs(:one)
  end

  test "should get index" do
    get packs_url
    assert_response :success
  end

  test "should get new" do
    get new_pack_url
    assert_response :success
  end

  test "should create pack" do
    assert_difference('Pack.count') do
      post packs_url, params: { pack: { description: @pack.description, name: @pack.name } }
    end

    assert_redirected_to pack_url(Pack.last)
  end

  test "should show pack" do
    get pack_url(@pack)
    assert_response :success
  end

  test "should get edit" do
    get edit_pack_url(@pack)
    assert_response :success
  end

  test "should update pack" do
    patch pack_url(@pack), params: { pack: { description: @pack.description, name: @pack.name } }
    assert_redirected_to pack_url(@pack)
  end

  test "should destroy pack" do
    assert_difference('Pack.count', -1) do
      delete pack_url(@pack)
    end

    assert_redirected_to packs_url
  end
end
