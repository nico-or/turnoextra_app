require "test_helper"

class ContactMessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    Rails.cache.clear

    @contact_message_params = {
      name: "John Doe",
      email: "john.doe@example.com",
      body: "This is a test message.",
      status: :unread,
      subject: :general
    }

    @default_params = { contact_message: @contact_message_params }
    @default_headers = { "User-Agent" => "Mozilla/5.0" }
  end

  test "should get contact page" do
    get contact_path
    assert_response :success
  end

  test "should create contact message with contact information" do
    assert_difference("ContactMessage.count", 1) do
      post contact_path, params: @default_params, headers: @default_headers
    end
    assert_equal @default_headers["User-Agent"], ContactMessage.last.user_agent
    assert_redirected_to contact_path
  end

  test "should create contact message without contact information" do
    @contact_message_params.delete(:name)
    @contact_message_params.delete(:email)
    assert_difference("ContactMessage.count", 1) do
      post contact_path, params: @default_params, headers: @default_headers
    end
    assert_equal @default_headers["User-Agent"], ContactMessage.last.user_agent
    assert_redirected_to contact_path
  end

  test "should not create contact message with blank body" do
    @contact_message_params.delete(:body)
    assert_no_difference "ContactMessage.count" do
      post contact_path, params: @default_params, headers: @default_headers
    end
  end

  test "should rate limit creating messages" do
    5.times do
      post contact_path, params: @default_params, headers: @default_headers
      assert_redirected_to contact_path
    end

    post contact_path, params: @default_params, headers: @default_headers
    assert_redirected_to contact_path
    assert_match (/limit/), flash[:alert]
  end
end
