require "test_helper"

class BoardgameDealTest < ActiveSupport::TestCase
  def setup
    @boardgame = Boardgame.create!(
      bgg_id: 42,
      title: "test_game",
      rank: 2,
      year: 2020,
    )

    @listing = @boardgame.listings.create!(
      store: Store.first,
      title: "test listing",
      url: "https://www.example.com/listing/1"
    )

    @listing.prices.create!(amount: 6_000, date: Date.current())
    @listing.prices.create!(amount: 10_000, date: Date.current() - 1)

    BoardgameDeal.refresh

    @deal = BoardgameDeal.find_by(id: @boardgame.id)
  end

  test "BoardgameDeal has correct Boardgame relation" do
    boardgame = @deal.boardgame
    assert_equal boardgame, @boardgame
  end

  test "Boardgame has correct BoardgameDeal relation" do
    boardgame_deal = @boardgame.boardgame_deal

    assert_equal boardgame_deal, @deal
  end
end
