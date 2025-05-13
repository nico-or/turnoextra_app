
require "test_helper"

module Bgg::Versions::XmlV1
  class BoardgameResponseParserTest < ActiveSupport::TestCase
    test "#parse! a XML response with a single boardgame" do
      xml = file_fixture("bgg/api/v1/query_single.xml").read
      response = Nokogiri::XML(xml)
      boardgames = BoardgameResponseParser.parse!(response)
      assert_equal 1, boardgames.size
      assert boardgames.is_a? Array
      assert boardgames.all? { |game| game.is_a? Bgg::Boardgame }

      game = boardgames.first
      assert_equal "Carcassonne", game.title
      assert_equal 2000, game.year
      assert_equal 822, game.bgg_id
      assert game.titles.is_a? Array
      assert_equal 23, game.titles.count
      assert_match %r{__thumb/img/}, game.thumbnail_url
      assert_match %r{__original/img/}, game.image_url
      assert_match %r{Carcassonne is a tile placement game}, game.description
    end

    test "#parse! a XML response with multiple boardgames" do
      xml = file_fixture("bgg/api/v1/query_multiple.xml").read
      response = Nokogiri::XML(xml)
      boardgames = BoardgameResponseParser.parse!(response)
      assert boardgames.is_a? Array
      assert_equal 2, boardgames.size
      assert boardgames.all? { |game| game.is_a? Bgg::Boardgame }

      game1 = boardgames[0]
      assert_equal "Wingspan", game1.title
      assert_equal 2019, game1.year
      assert_equal 266192, game1.bgg_id
      assert_equal 18, game1.titles.count

      game2 = boardgames[1]
      assert_equal "Pandemic", game2.title
      assert_equal 2008, game2.year
      assert_equal 30549, game2.bgg_id
      assert_equal 24, game2.titles.count
    end

    test "#parse! a XML response with no boardgames" do
      xml = file_fixture("bgg/api/v1/query_not_found.xml").read
      response = Nokogiri::XML(xml)
      boardgames = BoardgameResponseParser.parse!(response)
      assert boardgames.is_a? Array
      assert boardgames.empty?
    end

    test "#parse! a XML response with missing fields" do
      xml = file_fixture("bgg/api/v1/query_single_missing_fields.xml").read
      response = Nokogiri::XML(xml)
      boardgames = BoardgameResponseParser.parse!(response)
      assert boardgames.is_a? Array
      assert_equal 1, boardgames.size

      game = boardgames.first

      assert_nil game.title
      assert_nil game.year
      assert_nil game.description
      assert_nil game.thumbnail_url
      assert_nil game.image_url
    end
  end
end
