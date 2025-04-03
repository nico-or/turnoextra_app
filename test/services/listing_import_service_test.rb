require "test_helper"

class ListingCsvImportServiceTest < ActiveSupport::TestCase
  def setup
    @file_1 = file_fixture("listings/listing_1.csv")
    @file_2 = file_fixture("listings/listing_2.csv")
  end

  test "#call with listing_1.csv" do
    assert_difference("Store.count", 1) do
      assert_difference("Listing.count", 5) do
        assert_difference("Price.count", 5) do
          ListingCsvImportService.new(@file_1).call
        end
      end
    end
  end

  test "#call with listing_1.csv twice doesn't create more records" do
    assert_difference("Store.count", 1) do
      assert_difference("Listing.count", 5) do
        assert_difference("Price.count", 5) do
          2.times { ListingCsvImportService.new(@file_1).call }
        end
      end
    end
  end

  test "#call with listing_1.csv then listing_2.csv" do
    assert_difference("Store.count", 1) do
      assert_difference("Listing.count", 5) do
        assert_difference("Price.count", 10) do
          ListingCsvImportService.new(@file_1).call
          ListingCsvImportService.new(@file_2).call
        end
      end
    end

    listing = Listing.find_by(url: "https://devir.cl/8bit-box")
    latest_price_date = listing.prices.pluck(:date).max

    assert_equal 2, listing.prices.count
    assert_equal Date.new(2025, 03, 31), latest_price_date
  end
end
