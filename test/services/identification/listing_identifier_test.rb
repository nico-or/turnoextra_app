require "test_helper"
require "minitest/mock"

module Identification
class ListingIdentifierTest < ActiveSupport::TestCase
  setup do
    @listing = Listing.create!(
      title: "Test Game",
      boardgame_id: nil,
      store: Store.first,
      url: "https://example.com/listing/1"
    )

    @logger = Logger.new(STDOUT, level: :fatal)

    @search_result = SearchMethod::SearchResult.new(
      bgg_id: 123,
      title: "test game",
      year: Date.current.year,
      similarity: 1.0,
      rank: 1,
    )

    @search_method_class_mock_name = "SearchMethod::TestSearch"
    @search_method_class_mock = Minitest::Mock.new
    @search_method_class_mock.expect(:name, @search_method_class_mock_name)
    @search_method_class_mock.expect(:nil?, false)
  end

  test "identify! with no results" do
    @search_method_class_mock.expect(:call, [], [ @listing.title.downcase ])

    identifier = ListingIdentifier.new(
      search_method_class: @search_method_class_mock,
      logger: @logger
    )

    identifier.identify!(@listing)
    @listing.reload

    assert_nil @listing.boardgame_id
  end

  test "identify! with single result" do
    boardgame = Boardgame.create!(
      title: "Test Game",
      bgg_id: @search_result.bgg_id,
      rank: @search_result.rank,
      year: @search_result.year,
    )

    @search_method_class_mock.expect(:call, [ @search_result ], [ @listing.title.downcase ])

    identifier = ListingIdentifier.new(
      search_method_class: @search_method_class_mock,
      logger: @logger
    )

    identifier.identify!(@listing)
    @listing.reload

    assert_equal boardgame.id, @listing.boardgame_id
  end

  test "identify! with no result above threshold" do
    @search_result = @search_result.with(similarity: 0.2)

    @search_method_class_mock.expect(:call, [ @search_result ], [ @listing.title.downcase ])

    identifier = ListingIdentifier.new(
      search_method_class: @search_method_class_mock,
      logger: @logger
    )

    identifier.identify!(@listing)
    @listing.reload

    assert_nil @listing.boardgame_id
  end

  test "identify! with already failed listing" do
    @search_method_class_mock.expect(:call, [ @search_result ], [ @listing.title.downcase ])
    @search_method_class_mock.expect(:name, @search_method_class_mock_name)

    @listing.identification_failures.create!(
      search_method: @search_method_class_mock_name,
      reason: "test reason"
    )

    assert IdentificationFailure.exists?(identifiable: @listing, search_method: @search_method_class_mock_name)

    identifier = ListingIdentifier.new(
      search_method_class: @search_method_class_mock,
      logger: @logger
    )

    identifier.identify!(@listing)
    @listing.reload

    assert_nil @listing.boardgame_id
  end

  test "identify! with no database record for result" do
    @search_method_class_mock.expect(:call, [ @search_result ], [ @listing.title.downcase ])

    identifier = ListingIdentifier.new(
      search_method_class: @search_method_class_mock,
      logger: @logger
    )

    # Another option would be to pass a BoardgameSearcher-like Proc to the constructor
    # and pass a mock
    ::Boardgame.stub(:find_by, nil) do
      identifier.identify!(@listing)
    end

    @listing.reload

    assert_nil @listing.boardgame_id
  end
end
end
