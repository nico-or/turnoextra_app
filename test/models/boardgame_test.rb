require "test_helper"

class BoardgameTest < ActiveSupport::TestCase
  test "returns date of latest price update" do
    boardgame = boardgames(:pandemic)
    date = prices(:price_9).date

    assert_equal date, boardgame.update_date
  end

  test "returns the best current price" do
    boardgame = boardgames(:pandemic)
    price = prices(:price_9)

    assert_equal price, boardgame.best_price
  end

  test "returns nil if the game has no listings" do
    boardgame = boardgames(:wingspan)

    assert_nil boardgame.best_price
  end
end
