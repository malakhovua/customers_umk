require 'test_helper'

class CastomerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get castomer_index_url
    assert_response :success
  end

end
