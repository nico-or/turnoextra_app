
require "test_helper"

module Bgg::Versions::XmlV2
  class SearchResponseParserTest < ActiveSupport::TestCase
    def setup
      xml = file_fixture("bgg/api/v2/search.xml").read
      response = Nokogiri::XML(xml)
      @search_results = SearchResponseParser.parse!(response)
    end

    test "returns an array of SearchResults" do
      assert @search_results.is_a? Array
      assert @search_results.all? { |game| game.is_a? Bgg::SearchResult }
    end

    test "returns the correct amount of games" do
      assert_equal 4, @search_results.count
    end

    test "builds the first object correctly" do
      game = @search_results.first

      assert_equal "Wingspan", game.name
      assert_equal 2019, game.year
      assert_equal 266192, game.id
    end

    test "builds a game without year correctly" do
      game = @search_results[1]

      assert_equal "Wingspan Asia", game.name
      assert_nil game.year
      assert_equal 366161, game.id
    end
  end

  class EmptySearchResponseParserTest < ActiveSupport::TestCase
    def setup
      xml = file_fixture("bgg/api/v2/search_empty.xml").read
      response = Nokogiri::XML(xml)
      @search_results = SearchResponseParser.parse!(response)
    end

    test "when the response has no results, it returns an empty array" do
      assert @search_results.is_a? Array
      assert @search_results.empty?
    end
  end
end
