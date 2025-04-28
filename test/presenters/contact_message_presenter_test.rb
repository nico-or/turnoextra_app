require "test_helper"

class ContactMessagePresenterTest < ActiveSupport::TestCase
  def setup
    @default_params = {
      name: "John Doe",
      email: "john.doe@example.com",
      subject: "general",
      body: "This is a test message.",
      user_agent: "Mozilla/5.0"
    }
    @message = ContactMessage.new(@default_params)
    @presenter = ContactMessagePresenter.new(@message, nil)
  end

  test "should present anonymously if no name is provided" do
    [ nil, "" ].each do |name|
      @message.name = name
      assert_equal "Anonymous", @presenter.name
    end
  end

  test "should present anonymously if no email is provided" do
    [ nil, "" ].each do |email|
      @message.email = email
      assert_equal "No Email Provided", @presenter.email
    end
  end
end
