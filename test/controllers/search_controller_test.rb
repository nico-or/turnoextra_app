require "test_helper"

class SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get search with no params" do
    get search_path
    assert_response :success
  end

  test "should get search with query param" do
    get search_path, params: { query: "test" }
    assert_response :success
  end
end
