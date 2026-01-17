require "test_helper"

class Reports::StorePrices::CountCellTest < ActiveSupport::TestCase
  test "returns table-warning when z-score is 2 or higher" do
    # Mean 10, StdDev 2. Count 15 = Z-score 2.5
    cell = Reports::StorePrices::CountCell.new(
      count: 15, date: Date.today, store_mean: 10, store_std_dev: 2
    )
    assert_equal "table-warning", cell.class
  end

  test "returns nil when z-score is under 2" do
    cell = Reports::StorePrices::CountCell.new(
      count: 11, date: Date.today, store_mean: 10, store_std_dev: 2
    )
    assert_nil cell.class
  end
end
