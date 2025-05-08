require "test_helper"

class BggTest < ActiveSupport::TestCase
  test "Bgg.uri_for a Boardgame" do
    boardgame = Boardgame.first
    boardgame_id = boardgame.bgg_id
    boardgame_url = URI.parse("https://boardgamegeek.com/boardgame/#{boardgame_id}")
    assert_equal boardgame_url, Bgg.uri_for(boardgame)
  end

  test "Bgg.uri_for a Bgg::BoardGame" do
    boardgame = Bgg::Boardgame.new(
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
    bgg_id = 13
    boardgame_url = URI.parse("https://boardgamegeek.com/boardgame/#{bgg_id}")
    assert_equal boardgame_url, Bgg.uri_for(bgg_id)
  end

  test "Bgg.uri_for an invalid type" do
    assert_raises(ArgumentError) { Bgg.uri_for("13") }
    assert_raises(ArgumentError) { Bgg.uri_for("not_an_integer") }
    assert_raises(ArgumentError) { Bgg.uri_for(nil) }
    assert_raises(ArgumentError) { Bgg.uri_for(:symbol) }
  end
end
