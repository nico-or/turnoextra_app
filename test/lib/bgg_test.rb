require "test_helper"

class BggTest < ActiveSupport::TestCase
  def setup
    @boardgame =boardgames(:catan)
    @boardgame_url = URI.parse("https://boardgamegeek.com/boardgame/13")
  end
  test "Bgg.uri_for a Boardgame" do
    assert_equal @boardgame_url, Bgg.uri_for(@boardgame)
  end

  test "Bgg.uri_for a Bgg::BoardGame" do
    boardgame = Bgg::BoardGame.new(
      id: 822,
      name: nil,
      names: [],
      year: nil,
      description: nil,
      thumbnail_url: nil,
      image_url: nil
    )
    boardgame_url = URI.parse("https://boardgamegeek.com/boardgame/822")
    assert_equal boardgame_url, Bgg.uri_for(boardgame)
  end

  test "Bgg.uri_for a Bgg::SearchResult" do
    search_result = Bgg::SearchResult.new(
      id: 67239,
      name: nil,
      year: nil
    )
    boardgame_url = URI.parse("https://boardgamegeek.com/boardgame/67239")
    assert_equal boardgame_url, Bgg.uri_for(search_result)
  end

  test "Bgg.uri_for an Integer" do
    assert_equal @boardgame_url, Bgg.uri_for(13)
  end

  test "Bgg.uri_for a String" do
    assert_equal @boardgame_url, Bgg.uri_for("13")
  end
end
