
require "test_helper"

module Bgg::Versions::XmlV1
  class SearchResponseParserTest < ActiveSupport::TestCase
    def setup
      xml = file_fixture("bgg/api/v1/search.xml").read
      response = Nokogiri::XML(xml)
      @search_results = SearchResponseParser.parse!(response)
    end

    test "#games returns correct game count" do
      assert_equal 3, @search_results.count
    end

    test "#games resturns an array of BoardGames" do
    games = @search_results
    assert games.is_a? Array
    assert games.all? { |game| game.is_a? Bgg::SearchResult }
    end

    test "builds the first object correctly" do
      game = @search_results.first

      assert_equal "Battleground: Crossbows & Catapults", game.name
      assert_equal 2007, game.year
      assert_equal 30328, game.id
    end

    test "builds the last object correctly" do
      game = @search_results.last

      assert_equal "Crossbows and Catapults: Trojan Horse and Battle Shield", game.name
      assert_equal 1984, game.year
      assert_equal 9647, game.id
    end

    test "builds a game without year correctly" do
      game = @search_results[1]

      assert_equal "Crossbows and Catapults: Sea Battle Set", game.name
      assert_nil game.year
      assert_equal 19157, game.id
    end
  end

  class EmptySearchResponseParserTest < ActiveSupport::TestCase
    def setup
      xml = file_fixture("bgg/api/v1/search_empty.xml").read
      response = Nokogiri::XML(xml)
      @search_results = SearchResponseParser.parse!(response)
    end
    test "#games returns an empty array" do
    assert @search_results.is_a? Array
     assert @search_results.empty?
    end
  end
end
