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

  # Status Enum Tests

  test "a new listing has a pending status" do
    assert @listing.pending?
  end
  test "#identify! updates the listing correctly" do
    @listing.identify!(@boardgame)

    assert @listing.identified?
    assert @listing.boardgame = @boardgame
  end

  test "#rematch! reverts the listing to it's default identification state" do
    @listing.rematch!

    assert @listing.pending?
    assert_nil @listing.boardgame
  end

  test "#reject! marks a listing as not a boardgame" do
    @listing.reject!

    assert @listing.rejected?
    assert_nil @listing.boardgame
  end

  test "#fail! updates a pending listing correctly" do
    @listing.fail!

    assert @listing.failed?
    assert_nil @listing.boardgame
  end

  test "#fail! updates an identified listing correctly" do
    @listing.identify!(@boardgame)

    @listing.fail!

    assert @listing.failed?
    assert_nil @listing.boardgame
  end
end
