require "test_helper"

class BoardgamesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get boardgames_url
    assert_response :success
  end
end
