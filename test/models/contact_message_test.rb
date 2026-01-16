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

  test "should default status: unread" do
    assert @contact_message.unread?
  end

  # Validations

  test "should set status to read when marked as read" do
    @contact_message.read!
    assert @contact_message.read?
  end

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
end
