require "test_helper"

module SearchMethod
  class DatabaseSearchTest < ActiveSupport::TestCase
    test "#call with a boardgame that is in the database" do
      boardgame = Boardgame.first
      @service = DatabaseSearch.new(boardgame.title)
      results = @service.call

      assert results.is_a? Array
      assert results.all? { |result| result.is_a? Bgg::SearchResult }

      result = results.first
      assert_equal boardgame.title, result.name
      assert_equal boardgame.year, result.year
      assert_equal boardgame.bgg_id, result.id
    end

    test "#call with a listing that is in the database" do
      listing = Listing.joins(:boardgame).first
      assert_not_nil listing
      boardgame = listing.boardgame
      assert_not_nil boardgame

      @service = DatabaseSearch.new(listing.title)
      results = @service.call

      assert results.is_a? Array
      assert results.all? { |result| result.is_a? Bgg::SearchResult }

      result = results.first
      assert_equal listing.title, result.name
      assert_equal boardgame.year, result.year
      assert_equal boardgame.bgg_id, result.id
    end

    test "#call with a boardgame that is not in the database" do
      query = "test game not in db"
      @service = DatabaseSearch.new(query)

      results = @service.call
      assert results.is_a? Array
      assert results.empty?
    end
  end
end
