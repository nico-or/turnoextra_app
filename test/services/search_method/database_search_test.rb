require "test_helper"

module SearchMethod
  class DatabaseSearchTest < ActiveSupport::TestCase
    def setup
      Rails.cache.clear
    end

    test "#call with a ranked boardgame that is in the database" do
      boardgame = Boardgame.create!(title: "test game", rank: 1, bgg_id: 1, year: 2010)

      @service = DatabaseSearch.new(boardgame.title)
      results = @service.call

      assert results.is_a? Array
      assert results.all? { |result| result.is_a? Bgg::SearchResult }

      result = results.first
      assert_equal boardgame.title, result.title
      assert_equal boardgame.year, result.year
      assert_equal boardgame.bgg_id, result.bgg_id
    end

    test "#call with an unranked boardgame that is in the database" do
      boardgame = Boardgame.create!(title: "test game", rank: 0, bgg_id: 1, year: 2010)

      @service = DatabaseSearch.new(boardgame.title)
      results = @service.call

      assert results.is_a? Array
      assert results.empty?
    end

    test "#call with a ranked boardgame with a boardgame_name that is in the database" do
      boardgame = Boardgame.create!(title: "test game", rank: 1, bgg_id: 1, year: 2010)
      alternative_name = boardgame.boardgame_names.create!(value: "alternative name")

      @service = DatabaseSearch.new(alternative_name.value)
      results = @service.call

      assert results.is_a? Array
      assert results.all? { |result| result.is_a? Bgg::SearchResult }

      result = results.first
      assert_equal alternative_name.value, result.title
      assert_equal boardgame.year, result.year
      assert_equal boardgame.bgg_id, result.bgg_id
    end

    test "#call with a ranked listing that is in the database" do
      boardgame = Boardgame.create!(title: "test game", rank: 1, bgg_id: 1, year: 2010)
      listing = boardgame.listings.create!(title: "test listing", store: Store.first, url: "https://example.com")

      @service = DatabaseSearch.new(listing.title)
      results = @service.call

      assert results.is_a? Array
      assert results.all? { |result| result.is_a? Bgg::SearchResult }

      result = results.first
      assert_equal listing.title, result.title
      assert_equal boardgame.year, result.year
      assert_equal boardgame.bgg_id, result.bgg_id
    end

    test "#call with an unranked listing that is in the database" do
      boardgame = Boardgame.create!(title: "test game", rank: 0, bgg_id: 1, year: 2010)
      listing = boardgame.listings.create!(title: "test listing", store: Store.first, url: "https://example.com")

      boardgame.rank = 0
      boardgame.save!

      @service = DatabaseSearch.new(listing.title)
      results = @service.call

      assert results.is_a? Array
      assert results.empty?
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
