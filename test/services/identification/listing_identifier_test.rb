require "test_helper"
require "ostruct"
require "minitest/mock"

module Identification
class ListingIdentifierTest < ActiveSupport::TestCase
  setup do
    @logger = Logger.new(STDOUT, level: :fatal)
  end

  test "identify! with no results" do
    listing = OpenStruct.new(
      title: "Test Game",
      boardgame_id: nil,
    )

    search_method_class_mock = Minitest::Mock.new
    search_method_class_mock.expect(:call, [], [ listing.title.downcase ])
    search_method_class_mock.expect(:name, "SearchMethod::TestSearch")

    identifier = ListingIdentifier.new(
      search_method_class: search_method_class_mock,
      logger: @logger
    )

    identifier.identify!(listing)
    listing.reload

    assert_nil listing.boardgame_id
  end

  test "identify! with single result" do
    search_result = SearchMethod::SearchResult.new(
      bgg_id: 123,
      title: "test game",
      year: Date.today.year,
      similarity: 1.0,
      rank: 1,
    )

    boardgame = Boardgame.create!(
      title: "Test Game",
      bgg_id: search_result.bgg_id,
      rank: search_result.rank,
      year: search_result.year,
    )

    listing = Listing.create!(
      title: "Test Game",
      boardgame_id: nil,
      store: Store.first,
      url: "https://example.com/listing/1"
    )

    search_method_class_mock = Minitest::Mock.new
    search_method_class_mock.expect(:call, [ search_result ], [ listing.title.downcase ])
    search_method_class_mock.expect(:name, "SearchMethod::TestSearch")

    identifier = ListingIdentifier.new(
      search_method_class: search_method_class_mock,
      logger: @logger
    )

    identifier.identify!(listing)
    listing.reload

    assert_equal boardgame.id, listing.boardgame_id
  end

  test "identify! with no result above threshold" do
    skip
    # FIXME: refactor ListingIdentifier until is testable
    search_result = SearchMethod::SearchResult.new(
      bgg_id: 123,
      title: "test game",
      year: Date.today.year,
      similarity: 2.0,
      rank: 1,
    )


    listing = Listing.create!(
      title: "Test Game",
      boardgame_id: nil,
      store: Store.first,
      url: "https://example.com/listing/1"
    )

    search_method_class_mock = Minitest::Mock.new
    search_method_class_mock.expect(:call, [ search_result ], [ listing.title.downcase ])
    search_method_class_mock.expect(:name, "SearchMethod::TestSearch")

    identifier = ListingIdentifier.new(
      search_method_class: search_method_class_mock,
      logger: @logger
    )

    identifier.identify!(listing)
    listing.reload

    assert_nil listing.boardgame_id
  end
end
end
