require "test_helper"

class BoardgamesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get boardgames_url
    assert_response :success
  end

  test "should get index with a query" do
    get boardgames_url, params: { q: "foo" }
    assert_response :success
  end

  test "should get show" do
    boardgame = boardgames(:catan)
    get boardgame_url(boardgame)
    assert_response :success
  end
end
