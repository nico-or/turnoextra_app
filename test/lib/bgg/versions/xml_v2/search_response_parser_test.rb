
require "test_helper"

module Bgg::Versions::XmlV2
  class SearchResponseParserTest < ActiveSupport::TestCase
    test "#parse! a regular XML response with a single boardgame" do
      xml = file_fixture("bgg/api/v2/search_single.xml").read
      response = Nokogiri::XML(xml)
      search_results = SearchResponseParser.parse!(response)
      assert search_results.is_a? Array
      assert_equal 1, search_results.size

      game = search_results.first
      assert_equal "Wingspan", game.name
      assert_equal 2019, game.year
      assert_equal 266192, game.id
    end

    test "#parse! a regular XML response with multiple boardgames" do
      xml = file_fixture("bgg/api/v2/search_multiple.xml").read
      response = Nokogiri::XML(xml)
      search_results = SearchResponseParser.parse!(response)
      assert_equal 2, search_results.count

      game1 = search_results[0]
      assert_equal "Wingspan", game1.name
      assert_equal 2019, game1.year
      assert_equal 266192, game1.id

      game2 = search_results[1]
      assert_equal "Wingspan Asia", game2.name
      assert_nil game2.year
      assert_equal 366161, game2.id
    end

    test "#parse! handles an empty response" do
      xml = file_fixture("bgg/api/v2/search_empty.xml").read
      response = Nokogiri::XML(xml)
      search_results = SearchResponseParser.parse!(response)
      assert search_results.is_a? Array
      assert search_results.empty?
    end
  end
end
