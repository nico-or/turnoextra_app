require "test_helper"

class DealsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get deals_path
    assert_response :success
  end
end
