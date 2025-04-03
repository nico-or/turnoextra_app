require "test_helper"

class Admin::ListingsControllerUserTest < ActionDispatch::IntegrationTest
  test "should not get index" do
    get admin_listings_url
    assert_redirected_to login_path
  end
end

class Admin::ListingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_admin
  end

  test "should get index" do
    get admin_listings_url
    assert_response :success
  end

  test "should get show" do
    listing = listings(:pandemic_1)
    get admin_listing_url(listing)
    assert_response :success
  end
end
