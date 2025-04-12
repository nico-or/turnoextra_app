require "test_helper"

class BoardgameTest < ActiveSupport::TestCase
  test "should not allow empty titles" do
    boardgame = Boardgame.new(title: "", bgg_id: "12345")
    assert_not boardgame.valid?
  end

  test "should not allow missing titles" do
    boardgame = Boardgame.new(title: nil, bgg_id: "12345")
    assert_not boardgame.valid?
  end

  test "should not allow duplicate bgg_id" do
    boardgame = Boardgame.new(
      title: "New Game",
      bgg_id: boardgames(:pandemic).bgg_id
    )
    assert_not boardgame.valid?
  end

  test "should not allow negative bgg_id" do
    boardgame = Boardgame.new(title: "New Game", bgg_id: -1)
    assert_not boardgame.valid?
  end
  test "should not allow non-integer bgg_id" do
    boardgame = Boardgame.new(title: "New Game", bgg_id: "abc")
    assert_not boardgame.valid?
  end

  test "should not allow floating point bgg_id" do
    boardgame = Boardgame.new(title: "New Game", bgg_id: 123.45)
    assert_not boardgame.valid?
  end

  test "returns date of latest price update" do
    boardgame = boardgames(:pandemic)
    price = prices(:price_9)
    assert_equal price.date, boardgame.latest_price_date
  end

  test "#bgg_url returns returns correct BoardGameGeek url for a boardgame" do
    boardgame = boardgames(:pandemic)
    boardgame_url = "https://boardgamegeek.com/boardgame/#{boardgame.bgg_id}"
    assert_equal boardgame_url, boardgame.bgg_url
  end
end
