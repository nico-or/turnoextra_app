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

    test "#show should mark as read" do
      @contact_message.update(read: false)
      get admin_contact_message_path(@contact_message)
      @contact_message.reload
      assert @contact_message.read?
    end

    test "#mark_addressed" do
      @contact_message.update!(status: :pending, archived: false, read: false, spam: false)

      patch mark_addressed_admin_contact_message_path(@contact_message)
      @contact_message.reload

      assert_redirected_to admin_contact_message_path(@contact_message)
      assert @contact_message.addressed?, "Set status = addressed"
      assert @contact_message.archived?, "Set archived = true"
    end

    test "#mark_spam" do
      @contact_message.update!(status: :pending, archived: false, read: false, spam: false)

      patch mark_spam_admin_contact_message_path(@contact_message)
      @contact_message.reload

      assert_redirected_to admin_contact_message_path(@contact_message)
      assert @contact_message.archived?, "Set archived = true"
      assert @contact_message.dismissed?, "Set status = dismissed"
      assert @contact_message.spam?, "Set spam = true"
    end

    test "#reset_status" do
      @contact_message.update!(status: :dismissed, archived: true, read: true, spam: true)

      patch reset_status_admin_contact_message_path(@contact_message)
      @contact_message.reload

      assert_redirected_to admin_contact_message_path(@contact_message)
      assert @contact_message.pending?, "Set status = pending"
      assert_not @contact_message.archived?, "Set archived = false"
      assert_not @contact_message.read?, "Set read = false"
      assert_not @contact_message.spam?, "Set spam = false"
    end
  end
end
