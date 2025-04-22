require "test_helper"

class StoreSuggestionsControllerTest < ActionDispatch::IntegrationTest
  class UnauthenticatedUserTest < ActionDispatch::IntegrationTest
    def setup
      @url = "https://example.com"
    end

    test "should not get index" do
      get store_suggestions_path
      assert_redirected_to login_path
    end

    test "should get new" do
      get new_store_suggestion_path
      assert_response :success
    end

    test "should create store suggestion" do
      payload = { store_suggestion: { url: @url } }
      post store_suggestions_path, params: payload
      assert_redirected_to new_store_suggestion_path
    end

    test "should create multiple store suggestions for the same url" do
      assert_difference("StoreSuggestion.count", 2) do
        post store_suggestions_path, params: { store_suggestion: { url: @url } }
        post store_suggestions_path, params: { store_suggestion: { url: URI.join(@url, "foo").to_s } }
      end

      assert_equal 2, StoreSuggestion.where(url: @url).count
    end
  end

  test "should rate limit store suggestions" do
    10.times do
      post store_suggestions_path, params: { store_suggestion: { url: @url } }
    end

    post store_suggestions_path, params: { store_suggestion: { url: @url } }
    assert_response :redirect
    assert_redirected_to new_store_suggestion_path

    travel 1.minute + 1.second do
      post store_suggestions_path, params: { store_suggestion: { url: @url } }
      assert_response :success
    end
  end

  class AuthenticatedUserTest < ActionDispatch::IntegrationTest
    setup do
      login_admin
    end

    test "should get index" do
      get store_suggestions_path
      assert_response :success
    end
  end
end
