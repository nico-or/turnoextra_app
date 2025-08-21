
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
      assert_equal "HINT", game.title
      assert_equal 2014, game.year
      assert_equal 165628, game.bgg_id
      assert game.titles.is_a? Array
      assert_equal 4, game.titles.count
      assert_match %r{__thumb/img/}, game.thumbnail_url
      assert_match %r{__original/img/}, game.image_url
      assert_match %r{In HINT, your teammates}, game.description
      assert_equal 4, game.min_players
      assert_equal 10, game.max_players
      assert_equal 45, game.min_playtime
      assert_equal 60, game.max_playtime
      assert_equal 60, game.playingtime
      assert_equal 16, game.links.count
      assert_equal 1.2667, game.weight

      assert_equal [ "Party Game" ], game.categories
      assert_equal [ "Acting", "Line Drawing", "Singing", "Team-Based Game" ], game.mechanics
      assert_equal [ "Jesper Bülow", "Jonas Resting-Jeppesen" ], game.designers
      assert_equal [ "Jonas Resting-Jeppesen" ], game.artists
    end

    test "#parse! a XML response with multiple boardgames" do
      xml = file_fixture("bgg/api/v2/thing_multiple.xml").read
      response = Nokogiri::XML(xml)
      boardgames = ThingResponseParser.parse!(response)
      assert boardgames.is_a? Array
      assert_equal 2, boardgames.size
      assert boardgames.all? { |game| game.is_a? Bgg::Boardgame }

      game1 = boardgames[0]
      assert_equal "HINT", game1.title
      assert_equal 2014, game1.year
      assert_equal 165628, game1.bgg_id
      assert_equal 4, game1.titles.count

      game2 = boardgames[1]
      assert_equal "Dogsitter", game2.title
      assert_equal 2014, game2.year
      assert_equal 165629, game2.bgg_id
      assert_equal 1, game2.titles.count
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

      assert_nil game.title
      assert_nil game.year
      assert_nil game.description
      assert_nil game.thumbnail_url
      assert_nil game.image_url
    end
  end
end
