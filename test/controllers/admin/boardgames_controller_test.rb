require "test_helper"

class Admin::BoardgamesControllerUserTest < ActionDispatch::IntegrationTest
  test "should not get index" do
    get admin_boardgames_url
    assert_redirected_to login_url
  end
end

class Admin::BoardgamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_admin
  end

  test "should get index" do
    get admin_boardgames_url
    assert_response :success
  end

  test "should get show" do
    boardgame = boardgames(:catan)
    get admin_boardgame_url(boardgame)
    assert_response :success
  end
end
