require "test_helper"

module Admin
  class ReportsControllerTest < ActionDispatch::IntegrationTest
    setup do
      login_admin
    end

    test "should get admin_reports_store_prices_count_path" do
      get admin_reports_store_prices_count_path
      assert_response :success
    end
  end
end
