require "test_helper"

class ContactMessageTest < ActiveSupport::TestCase
  def setup
    @default_params = {
      name: "John Doe",
      email: "john.doe@example.com",
      body: "This is a test message.",
      user_agent: "Mozilla/5.0"
    }
  end

  test "should be valid with default params" do
    contact_message = ContactMessage.new(@default_params)
    assert contact_message.valid?
  end

  test "should be unread by default" do
    contact_message = ContactMessage.new(@default_params)
    assert contact_message.unread?
  end

  test "should set status to read when marked as read" do
    contact_message = ContactMessage.create(@default_params)
    contact_message.read!
    assert contact_message.read?
  end

  test "should be valid without a name" do
    @default_params.delete(:name)
    contact_message = ContactMessage.new(@default_params)
    assert contact_message.valid?
  end

  test "should be valid without an email" do
    @default_params.delete(:email)
    contact_message = ContactMessage.new(@default_params)
    assert contact_message.valid?

    contact_message.save
    assert_nil contact_message.email
  end

  test "should default to 'general' subject if none is provided" do
    @default_params.delete(:subject)
    contact_message = ContactMessage.new(@default_params)
    assert contact_message.general?
  end

  test "shoudl default to unread status if none is provided" do
    @default_params.delete(:status)
    contact_message = ContactMessage.new(@default_params)
    assert contact_message.unread?
  end

  test "should not be valid with an invalid email format" do
    @default_params[:email] = "invalid_email"
    contact_message = ContactMessage.new(@default_params)
    assert_not contact_message.valid?
  end

  test "should not be valid without a body" do
    @default_params.delete(:body)
    contact_message = ContactMessage.new(@default_params)
    assert_not contact_message.valid?
  end

  test "should downcase the email before saving" do
    @default_params[:email] = "TEST@EXAMPLE.COM"
    contact_message = ContactMessage.new(@default_params)
    contact_message.save!
    assert_equal "test@example.com", contact_message.email
  end
end
