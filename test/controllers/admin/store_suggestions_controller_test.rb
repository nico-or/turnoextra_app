require "test_helper"

class Admin::StoreSuggestionsControllerTest < ActionDispatch::IntegrationTest
  class UnauthenticatedUserTest < ActionDispatch::IntegrationTest
    test "should not get index" do
      get admin_store_suggestions_path
      assert_redirected_to login_path
    end
  end

  class AuthenticatedUserTest < ActionDispatch::IntegrationTest
    setup do
      login_admin
    end

    test "should get index" do
      get admin_store_suggestions_path
      assert_response :success
    end
  end
end
