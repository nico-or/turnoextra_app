require "test_helper"

class ContactMessageTest < ActiveSupport::TestCase
  def setup
    @default_params = {
      name: "John Doe",
      email: "john.doe@example.com",
      body: "This is a test message.",
      user_agent: "Mozilla/5.0"
    }
    @contact_message = ContactMessage.new(@default_params)
  end

  # Default Status

  test "should default to subject: general" do
    assert @contact_message.general?
  end

  test "should default status: pending" do
    assert @contact_message.pending?
  end

  test "should default to archived_status: active" do
    assert @contact_message.active?
  end

  test "should default to spam_status: false" do
    assert @contact_message.legit?
  end

  test "should default to read_status: unread" do
    assert @contact_message.unread?
  end

  # Validations

  test "should be valid without a name" do
    @contact_message.name = nil
    assert @contact_message.valid?
  end

  test "should be valid without an email" do
    @contact_message.email = nil
    assert @contact_message.valid?
  end

  test "should not be valid with an invalid email format" do
    @contact_message.email = "invalid_email"
    assert_not @contact_message.valid?
  end

  test "should not be valid without a body" do
    @contact_message.body = nil
    assert_not @contact_message.valid?
  end

  test "should downcase the email before saving" do
    @contact_message.email = "TEST@EXAMPLE.COM"
    assert @contact_message.valid? # force validation hooks
    assert_equal "test@example.com", @contact_message.email
  end

  # Relations

  test "should allow polymorphic relationship with contactable" do
    contactable = Boardgame.first
    @contact_message.contactable = contactable
    assert @contact_message.valid?
    assert @contact_message.contactable_id = contactable.id
    assert @contact_message.contactable_type = contactable.class.name
  end

  # Status update utility methods

  test "#mark_addressed!" do
    @contact_message.mark_addressed!

    assert @contact_message.addressed?
    assert @contact_message.archived?
end

  test "#mark_spam!" do
    @contact_message.mark_spam!

    assert @contact_message.spam?
    assert @contact_message.dismissed?
    assert @contact_message.archived?
end

  test "#reset_status!" do
    @contact_message.mark_spam!
    @contact_message.reset_status!

    assert @contact_message.unread?
    assert @contact_message.pending?
    assert @contact_message.active?
    assert @contact_message.legit?
  end
end
