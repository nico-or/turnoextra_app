require "test_helper"

class BoardgamesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get boardgames_url
    assert_response :success
  end

  test "should get show" do
    get boardgame_url(Boardgame.first)
    assert_response :success
  end
end
