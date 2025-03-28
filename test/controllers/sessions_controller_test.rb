require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_path
    assert_response :success
  end

  test "should login with correct credentials" do
    user = users(:admin)
    post login_path, params: { email: user.email, password: "password" }

    assert_equal session[:user_id], user.id
    assert_redirected_to root_path
  end

  test "should not login with incorrect credentials" do
    payload = { email: "admin@example.com", password: "invalid" }
    post login_path, params: payload

    assert_nil session[:user_id]
    assert_response :unprocessable_entity
  end

  test "should logout a logged in user" do
    login_admin
    delete logout_path

    assert_nil session[:user_id]
    assert_redirected_to root_url
  end
end
