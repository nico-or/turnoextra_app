require "test_helper"

class StoreSuggestionTest < ActiveSupport::TestCase
  setup do
    @default_params = {
      url: "http://example.com"
    }
  end

  test "should not save store suggestion without url" do
    params = @default_params.merge(url: nil)
    store_suggestion = StoreSuggestion.new(params)
    assert_not store_suggestion.valid?
  end

  test "should save store suggestion with valid params" do
    params = @default_params
    store_suggestion = StoreSuggestion.new(params)
    assert store_suggestion.valid?
  end

  test "should normalize url before saving" do
    params = @default_params.merge(url: "HTTP://EXAMPLE.COM")
    store_suggestion = StoreSuggestion.create(params)
    assert_equal "http://example.com", store_suggestion.url
  end

  test "should only store url origin" do
    params = @default_params.merge(url: "https://www.example.com/path/to/page?query=string#fragment")
    store_suggestion = StoreSuggestion.create(params)
    assert_equal "https://www.example.com", store_suggestion.url
  end

  test "should validate url format" do
    params = @default_params.merge(url: "not a valid url")
    store_suggestion = StoreSuggestion.new(params)
    assert_not store_suggestion.valid?
  end

  test "should only work with http and https urls" do
    params = @default_params.merge(url: "ftp://example.com")
    store_suggestion = StoreSuggestion.new(params)
    assert_not store_suggestion.valid?
  end
end
