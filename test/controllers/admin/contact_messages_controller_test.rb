require "test_helper"

class Admin::ContactMessagesControllerTest < ActionDispatch::IntegrationTest
  class UnauthenticatedUserTest < ActionDispatch::IntegrationTest
    test "should redirect to login page if not authenticated" do
      get admin_contact_messages_path
      assert_redirected_to login_path
    end
  end

  class AuthenticatedUserTest < ActionDispatch::IntegrationTest
    setup do
      login_admin
      @contact_message = contact_messages(:one)
    end

    test "should get index" do
      get admin_contact_messages_path
      assert_response :success
    end

    test "should show contact message" do
      get admin_contact_message_path(@contact_message)
      assert_response :success
    end

    test "should toggle read status of contact message" do
      before_status = @contact_message.status
      post toggle_read_admin_contact_message_path(@contact_message)
      after_status = @contact_message.reload.status

      assert before_status != after_status
      assert_redirected_to admin_contact_message_path(@contact_message)
    end
  end
end
