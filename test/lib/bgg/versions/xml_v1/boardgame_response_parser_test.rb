
require "test_helper"

module Bgg::Versions::XmlV1
  class BoardgameResponseParserTest < ActiveSupport::TestCase
    def setup
      xml = file_fixture("bgg/api/v1/query_single.xml").read
      response = Nokogiri::XML(xml)
      @boardgames = BoardgameResponseParser.parse!(response)
      @boardgame = @boardgames.first
    end

    test "#games returns an array of BoardGames" do
      assert @boardgames.is_a? Array
      assert @boardgames.all? { |game| game.is_a? Bgg::Boardgame }
    end

    test "buils the correct BoardGame" do
      assert_equal 822, @boardgame.id
      assert_equal 2000, @boardgame.year
      assert_equal "Carcassonne", @boardgame.name
      assert_equal 23, @boardgame.names.count
    end
  end

  class MultipleBoardgameResponseParserTest < ActiveSupport::TestCase
    def setup
      xml = file_fixture("bgg/api/v1/query_multiple.xml").read
      response = Nokogiri::XML(xml)
      @boardgames = BoardgameResponseParser.parse!(response)
    end

    test "#games returns an array of BoardGames" do
      assert_equal 2, @boardgames.count
      assert @boardgames.is_a? Array
      assert @boardgames.all? { |game| game.is_a? Bgg::Boardgame }
    end
  end

  class NotFoundBoardgameResponseParserTest < ActiveSupport::TestCase
    def setup
      xml = file_fixture("bgg/api/v1/query_not_found.xml").read
      response = Nokogiri::XML(xml)
      @boardgames = BoardgameResponseParser.parse!(response)
    end

    test "#games returns an empty array" do
      assert @boardgames.empty?
      assert @boardgames.is_a? Array
    end
  end
end
