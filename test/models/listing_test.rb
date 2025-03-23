require "test_helper"

class ListingTest < ActiveSupport::TestCase
  test "returns latest update date" do
    listing = listings(:pandemic_2)
    date = prices(:price_9).date

    assert_equal date, listing.update_date
  end

  test "returns latest price" do
    listing = listings(:pandemic_2)
    price = prices(:price_9)

    assert_equal price, listing.latest_price
  end
end
