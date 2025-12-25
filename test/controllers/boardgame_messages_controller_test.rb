require "test_helper"

class BoardgameMessagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @boardgame = Boardgame.first
  end
  test "should get new" do
    get new_boardgame_message_path(@boardgame)

    assert_response :success
  end

  test "should create new contact messages" do
    assert_difference "ContactMessage.count", 1 do
      post boardgame_messages_path(@boardgame),
      params: { contact_message: { body: "test message" } },
      headers: { "User-agent" => "test user agent" }

      assert_redirected_to boardgame_path(@boardgame)
    end

    p message = ContactMessage.last

    assert message.error_report?
    assert_equal @boardgame, message.contactable
    assert_equal "test message", message.body
  end

  test "should not create new contact messages" do
    assert_no_difference "ContactMessage.count" do
      post boardgame_messages_path(@boardgame),
        params: nil, headers: nil

      assert_response :bad_request
    end
  end
end
