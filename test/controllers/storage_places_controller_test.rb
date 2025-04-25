require 'test_helper'

class StoragePlacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @storage_place = storage_places(:one)
  end

  test "should get index" do
    get storage_places_url
    assert_response :success
  end

  test "should get new" do
    get new_storage_place_url
    assert_response :success
  end

  test "should create storage_place" do
    assert_difference('StoragePlace.count') do
      post storage_places_url, params: { storage_place: {  } }
    end

    assert_redirected_to storage_place_url(StoragePlace.last)
  end

  test "should show storage_place" do
    get storage_place_url(@storage_place)
    assert_response :success
  end

  test "should get edit" do
    get edit_storage_place_url(@storage_place)
    assert_response :success
  end

  test "should update storage_place" do
    patch storage_place_url(@storage_place), params: { storage_place: {  } }
    assert_redirected_to storage_place_url(@storage_place)
  end

  test "should destroy storage_place" do
    assert_difference('StoragePlace.count', -1) do
      delete storage_place_url(@storage_place)
    end

    assert_redirected_to storage_places_url
  end
end
