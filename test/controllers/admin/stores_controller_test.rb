require "test_helper"

class Admin::StoresControllerUserTest < ActionDispatch::IntegrationTest
  test "should not get index" do
    get admin_stores_path
    assert_redirected_to login_path
  end
end

class Admin::StoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_admin
  end

  test "should get index" do
    get admin_stores_path
    assert_response :success
  end

  test "should show store" do
    store = stores(:devir)
    get admin_store_path(store)
    assert_response :success
  end
end
