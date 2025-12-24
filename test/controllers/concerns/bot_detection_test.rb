require "test_helper"

class BotDetectionTest < ActionDispatch::IntegrationTest
  # Dummy controller to test ApplicationController filters
  class TestController < ApplicationController
    def index
      render json: { is_bot: Current.bot }
    end
  end

  # Setup a temporary route for the test
  setup do
    Rails.application.routes.draw do
      get "test_bot" => "bot_detection_test/test#index"
    end
  end

  # Restore routes after test
  teardown do
    Rails.application.reload_routes!
  end

  test "correctly identifies empty user agent" do
    user_agent = ""
    get "/test_bot", headers: { "User-Agent" => user_agent }
    assert_equal true, JSON.parse(response.body)["is_bot"]
  end

  test "correctly identifies Googlebot" do
    user_agent = "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.122 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
    get "/test_bot", headers: { "User-Agent" => user_agent }
    assert_equal true, JSON.parse(response.body)["is_bot"]
  end

  test "correctly identifies real user" do
    user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36"
    get "/test_bot", headers: { "User-Agent" => user_agent }
    assert_equal false, JSON.parse(response.body)["is_bot"]
  end
end
