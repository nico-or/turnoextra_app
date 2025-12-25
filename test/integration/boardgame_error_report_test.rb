require "test_helper"

class BoardgameMessageTest < ActionDispatch::IntegrationTest
  setup do
    @boardgame = boardgames(:catan)
  end

  test "visitors should be able report error on boardgame information" do
    get boardgame_path(@boardgame)
    assert_response :success
    assert_dom "a", href: new_boardgame_message_path(@boardgame)

    get new_boardgame_message_path(@boardgame)
    assert_response :success

    post boardgame_messages_path(@boardgame),
      params: { contact_message: { body: "test message" } },
      headers: { "User-agent" => "test user agent" }

    assert_redirected_to boardgame_path(@boardgame)
    follow_redirect!

    assert_dom "div.alert", text: /éxito/
  end

  test "shows error flash when message is invalid" do
    post boardgame_messages_path(@boardgame),
        params: { contact_message: { body: "" } },
        headers: { "User-Agent" => "test user agent" }

    assert_response :unprocessable_entity
    assert_dom "div.alert", text: /mal/i
  end
end
