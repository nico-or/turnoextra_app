require "test_helper"

class ListingTest < ActiveSupport::TestCase
  def setup
    @store = stores(:devir)

    @boardgame = boardgames(:pandemic)

    @listing = Listing.new(
      title: "Test Game",
      url: "https://www.example.com/test-game",
      store_id: @store.id
    )
  end

  test "should create a listing without a boardgame" do
    assert @listing.valid?
  end

  test "should create a listing with a boardgame" do
    @listing.boardgame = @boardgame
    assert @listing.valid?
  end

  test "should not allow creation without store_id" do
    @listing.store = nil
    assert_not @listing.valid?
  end

  test "should not allow creation without title" do
    @listing.title = nil
    assert_not @listing.valid?
  end

  test "should not allow creation without url" do
    @listing.url = nil
    assert_not @listing.valid?
  end

  test "#latest_price_date returns latest price date" do
    listing = listings(:pandemic_2)
    date = prices(:price_9).date

    assert_equal date, listing.latest_price_date
  end
end
