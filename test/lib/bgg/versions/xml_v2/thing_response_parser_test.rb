
require "test_helper"

module Bgg::Versions::XmlV2
  class ThingResponseParserTest < ActiveSupport::TestCase
    def setup
      xml = file_fixture("bgg/api/v2/thing.xml").read
      response = Nokogiri::XML(xml)
      @boardgames = ThingResponseParser.parse!(response)
      @boardgame = @boardgames.first
    end

    test "returns an array of BoardGames" do
      assert_equal 1, @boardgames.count
      assert @boardgames.is_a? Array
      assert @boardgames.all? { |game| game.is_a? Bgg::BoardGame }
    end

    test "buils the correct BoardGame" do
      assert_equal 165628, @boardgame.id
      assert_equal 2014, @boardgame.year
      assert_equal "HINT", @boardgame.name
      assert_equal 4, @boardgame.names.count
      assert_equal "https://cf.geekdo-images.com/1Ebkya5qKEm0SWGiAI20DA__thumb/img/sZw3_Zh6UNEcSYwcEUNqckHzn4k=/fit-in/200x150/filters:strip_icc()/pic6164116.jpg", @boardgame.thumbnail_url
      assert_equal "https://cf.geekdo-images.com/1Ebkya5qKEm0SWGiAI20DA__original/img/GZX5k_F8VHt8GVf2g1WZPFjGZ0Q=/0x0/filters:format(jpeg)/pic6164116.jpg", @boardgame.image_url
    end
  end

  class EmptyThingResponseParserTest < ActiveSupport::TestCase
    def setup
      xml = file_fixture("bgg/api/v2/thing_empty.xml").read
      response = Nokogiri::XML(xml)
      @boardgames = ThingResponseParser.parse!(response)
    end

    test "#games returns an empty array" do
      assert @boardgames.empty?
      assert @boardgames.is_a? Array
    end
  end
end
