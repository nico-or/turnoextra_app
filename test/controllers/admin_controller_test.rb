require "test_helper"

class AdminControllerUserTest < ActionDispatch::IntegrationTest
  test "should be redirected to login" do
    get dashboard_path
    assert_redirected_to login_path
  end
end

class AdminControllerAdmiTest < ActionDispatch::IntegrationTest
  setup do
    login_admin
  end

  test "should get index - dashboard" do
    get dashboard_path
    assert_response :success
  end
end
