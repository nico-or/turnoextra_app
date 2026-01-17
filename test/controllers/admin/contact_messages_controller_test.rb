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
      @contact_message.unread!
      get admin_contact_message_path(@contact_message)
      @contact_message.reload
      assert @contact_message.read_status?
    end

    test "#mark_addressed" do
      @contact_message.update!(
        status: :pending, archived_status: :active, read_status: :unread, spam_status: :legit)

      patch mark_addressed_admin_contact_message_path(@contact_message)
      @contact_message.reload

      assert_redirected_to admin_contact_message_path(@contact_message)
      assert @contact_message.addressed?
      assert @contact_message.archived?
    end

    test "#mark_spam" do
      @contact_message.update!(
        status: :pending, archived_status: :active, read_status: :unread, spam_status: :legit)

      patch mark_spam_admin_contact_message_path(@contact_message)
      @contact_message.reload

      assert_redirected_to admin_contact_message_path(@contact_message)
      assert @contact_message.archived?
      assert @contact_message.dismissed?
      assert @contact_message.spam?
    end

    test "#reset_status" do
      @contact_message.update!(
        status: :dismissed, archived_status: :archived, read_status: :read, spam_status: :spam)

      patch reset_status_admin_contact_message_path(@contact_message)
      @contact_message.reload

      assert_redirected_to admin_contact_message_path(@contact_message)
      assert @contact_message.pending?
      assert @contact_message.active?
      assert @contact_message.unread?
      assert @contact_message.legit?
    end
  end
end
