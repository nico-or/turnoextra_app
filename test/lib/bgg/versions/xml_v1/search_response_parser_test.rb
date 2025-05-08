
require "test_helper"

module Bgg::Versions::XmlV1
  class SearchResponseParserTest < ActiveSupport::TestCase
    test "#parse! a regular XML response with a single boardgame" do
      xml = file_fixture("bgg/api/v1/search_single.xml").read
      response = Nokogiri::XML(xml)
      search_results = SearchResponseParser.parse!(response)
      assert search_results.is_a? Array
      assert_equal 1, search_results.size

      game = search_results.first
      assert_equal "Battleground: Crossbows & Catapults", game.name
      assert_equal 2007, game.year
      assert_equal 30328, game.id
    end

    test "#parse! a regular XML response with multiple boardgames" do
      xml = file_fixture("bgg/api/v1/search_multiple.xml").read
      response = Nokogiri::XML(xml)
      search_results = SearchResponseParser.parse!(response)
      assert_equal 2, search_results.count

      game1 = search_results[0]
      assert_equal "Battleground: Crossbows & Catapults", game1.name
      assert_equal 2007, game1.year
      assert_equal 30328, game1.id

      game2 = search_results[1]
      assert_equal "Crossbows and Catapults: Sea Battle Set", game2.name
      assert_nil game2.year
      assert_equal 19157, game2.id
    end

    test "#parse! a XML response with a single boardgame wihtout name or year" do
      xml = file_fixture("bgg/api/v1/search_single_missing_fields.xml").read
      response = Nokogiri::XML(xml)
      search_results = SearchResponseParser.parse!(response)
      assert search_results.is_a? Array
      assert_equal 1, search_results.size

      game = search_results.first
      assert_nil game.name
      assert_nil game.year
      assert_equal 30328, game.id
    end

    test "#parse! handles an empty response" do
      xml = file_fixture("bgg/api/v1/search_empty.xml").read
      response = Nokogiri::XML(xml)
      search_results = SearchResponseParser.parse!(response)
      assert search_results.is_a? Array
      assert search_results.empty?
    end
  end
end
