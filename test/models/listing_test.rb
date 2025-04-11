require "test_helper"

class ListingTest < ActiveSupport::TestCase
  def setup
    @store = stores(:devir)
    @boardgame = boardgames(:pandemic)
    @listing_params = {
      title: "New Game",
      url: "www.example.com",
      store_id: @store.id,
      boardgame_id: @boardgame.id
    }
  end

  test "should create a new listing with valid attributes" do
    listing = Listing.new(@listing_params)
    assert listing.save
  end

  test "shold not allow creation without store_id" do
    params = @listing_params.merge(store_id: nil)
    listing = Listing.new(params)
    assert_not listing.valid?
  end
  test "shold not allow creation without title" do
    params = @listing_params.merge(title: nil)
    listing = Listing.new(params)
    assert_not listing.valid?
  end

  test "should not allow creation without url" do
    params = @listing_params.merge(url: nil)
    listing = Listing.new(params)
    assert_not listing.valid?
  end

  test "#latest_price_date returns latest price date" do
    listing = listings(:pandemic_2)
    date = prices(:price_9).date

    assert_equal date, listing.latest_price_date
  end

  # This allows async (background jobs) and manual
  # identification/reconcilitiation with the BGG database
  test "allows creation without boardgame_id" do
    store = stores(:entrejuegos)
    assert_difference("Listing.count") do
      store.listings.create!(
        title: "test",
        url: "www.example.com",
      )
    end
  end
end
