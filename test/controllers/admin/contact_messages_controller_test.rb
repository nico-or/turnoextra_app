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

    test "should toggle read status from unread to read" do
      @contact_message.unread!
      post toggle_read_admin_contact_message_path(@contact_message)
      @contact_message.reload
      assert_redirected_to admin_contact_message_path(@contact_message)
      assert @contact_message.read?
    end

    test "should toggle read status from read to unread" do
      @contact_message.read!
      post toggle_read_admin_contact_message_path(@contact_message)
      @contact_message.reload
      assert_redirected_to admin_contact_message_path(@contact_message)
      assert @contact_message.unread?
    end
  end
end
