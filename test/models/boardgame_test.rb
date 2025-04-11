require "test_helper"

class BoardgameTest < ActiveSupport::TestCase
  test "returns date of latest price update" do
    boardgame = boardgames(:pandemic)
    date = prices(:price_9).date

    assert_equal date, boardgame.update_date
  end

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
end
