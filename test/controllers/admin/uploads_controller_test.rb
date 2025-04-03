require "test_helper"

class Admin::UploadsControllerUserTest < ActionDispatch::IntegrationTest
  test "users can't access" do
    get new_admin_upload_path
    assert_redirected_to login_path
  end
end

class Admin::UploadsControllerAdminTest < ActionDispatch::IntegrationTest
  setup do
    login_admin
  end

  test "should get new" do
    get new_admin_upload_path
    assert_response :success
  end

  test "post invalid request" do
    post admin_uploads_path, params: { files: nil }
    assert_response :bad_request
  end

  test "post a single file" do
    csv_data = file_fixture_upload("devir.csv")

    assert_difference(-> { Store.count } => 1, -> { Listing.count } => 4, -> { Price.count }=> 4) do
      post admin_uploads_path, params: { files: [ csv_data ] }
    end

    assert_response :success
  end

  test "post multiple files" do
    csv_data_1 = file_fixture_upload("devir.csv")
    csv_data_2 = file_fixture_upload("entrejuegos.csv")

    assert_difference(-> { Store.count } => 2, -> { Listing.count } => 8, "Price.count"=> 8) do
      post admin_uploads_path, params: { files: [ csv_data_1, csv_data_2 ] }
    end
    assert_response :success
  end
end
