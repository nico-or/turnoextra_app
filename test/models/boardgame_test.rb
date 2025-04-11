require "test_helper"

class BoardgameTest < ActiveSupport::TestCase
  test "returns date of latest price update" do
    boardgame = boardgames(:pandemic)
    date = prices(:price_9).date

    assert_equal date, boardgame.update_date
  end
end
