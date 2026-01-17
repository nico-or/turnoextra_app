require "test_helper"
require "ostruct"

class Reports::StorePrices::StoreRowTest < ActiveSupport::TestCase
  setup do
    @store = OpenStruct.new(id: 1, url: "http://example.com")
    @records = [
      OpenStruct.new(price_count: 10),
      OpenStruct.new(price_count: 20)
    ]
  end

  test "calculates mean correctly" do
    row = Reports::StorePrices::StoreRow.new(@store, @records)
    assert_equal 15.0, row.send(:mean)
  end

  test "calculates std_dev correctly using sample formula (n-1)" do
    # For [10, 20], mean is 15.
    # Variance = ((10-15)^2 + (20-15)^2) / (2-1) = (25 + 25) / 1 = 50
    # Std Dev = sqrt(50) ~ 7.07
    records = [ OpenStruct.new(price_count: 10), OpenStruct.new(price_count: 20) ]
    row = Reports::StorePrices::StoreRow.new(@store, @records)
    assert_in_delta Math.sqrt(50), row.send(:std_dev), 0.01
  end

  test "returns NullCountCell when no record exists for date" do
    row = Reports::StorePrices::StoreRow.new(@store, [])
    assert_instance_of Reports::StorePrices::NullCountCell, row.cell_for(Date.today)
  end

  test "handles a single record correctly" do
    records = [ @records.first ]
    row = Reports::StorePrices::StoreRow.new(@store, records)
    assert_equal 10.0, row.send(:mean)
    assert_equal 0.0, row.send(:std_dev)
  end

  test "handles an empty records list" do
    records = []
    row = Reports::StorePrices::StoreRow.new(@store, records)
    assert_nil row.send(:mean)
    assert_nil row.send(:std_dev)
  end
end
