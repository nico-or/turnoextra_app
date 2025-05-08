
require "test_helper"

module Bgg::Versions::XmlV2
  class ThingResponseParserTest < ActiveSupport::TestCase
    test "#parse! a XML response with a single boardgame" do
      xml = file_fixture("bgg/api/v2/thing_single.xml").read
      response = Nokogiri::XML(xml)
      boardgames = ThingResponseParser.parse!(response)
      assert_equal 1, boardgames.size
      assert boardgames.is_a? Array
      assert boardgames.all? { |game| game.is_a? Bgg::Boardgame }

      game = boardgames.first
      assert_equal "HINT", game.name
      assert_equal 2014, game.year
      assert_equal 165628, game.id
      assert game.names.is_a? Array
      assert_equal 4, game.names.count
      assert_match %r{__thumb/img/}, game.thumbnail_url
      assert_match %r{__original/img/}, game.image_url
      assert_match %r{In HINT, your teammates}, game.description
    end

    test "#parse! a XML response with multiple boardgames" do
      xml = file_fixture("bgg/api/v2/thing_multiple.xml").read
      response = Nokogiri::XML(xml)
      boardgames = ThingResponseParser.parse!(response)
      assert boardgames.is_a? Array
      assert_equal 2, boardgames.size
      assert boardgames.all? { |game| game.is_a? Bgg::Boardgame }

      game1 = boardgames[0]
      assert_equal "HINT", game1.name
      assert_equal 2014, game1.year
      assert_equal 165628, game1.id
      assert_equal 4, game1.names.count

      game2 = boardgames[1]
      assert_equal "Dogsitter", game2.name
      assert_equal 2014, game2.year
      assert_equal 165629, game2.id
      assert_equal 1, game2.names.count
    end

    test "#parse! a XML response with no boardgames" do
      xml = file_fixture("bgg/api/v2/thing_not_found.xml").read
      response = Nokogiri::XML(xml)
      boardgames = ThingResponseParser.parse!(response)
      assert boardgames.is_a? Array
      assert boardgames.empty?
    end

    test "#parse! a XML response with missing fields" do
      xml = file_fixture("bgg/api/v2/thing_single_missing_fields.xml").read
      response = Nokogiri::XML(xml)
      boardgames = ThingResponseParser.parse!(response)
      assert boardgames.is_a? Array
      assert_equal 1, boardgames.size

      game = boardgames.first

      assert_nil game.name
      assert_nil game.year
      assert_nil game.description
      assert_nil game.thumbnail_url
      assert_nil game.image_url
    end
  end
end
