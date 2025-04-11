require "test_helper"

class ListingTest < ActiveSupport::TestCase
  test "returns latest update date" do
    listing = listings(:pandemic_2)
    date = prices(:price_9).date

    assert_equal date, listing.update_date
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
