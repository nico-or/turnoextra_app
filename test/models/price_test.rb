require "test_helper"

class PriceTest < ActiveSupport::TestCase
  def setup
    @listing = listings(:pandemic_1)
    @default_params = {
      listing_id: @listing.id,
      amount: 10_000,
      date: Date.today
    }
  end

  test "should create a new price with valid attributes" do
    price = Price.new(@default_params)
    assert_difference("Price.count", 1) do
      assert price.save
    end
  end

  test "shold not allow creation without listing_id" do
    params = @default_params.merge(listing_id: nil)
    price = Price.new(params)
    assert_not price.valid?
    assert_difference("Price.count", 0) do
      assert_not price.save
    end
  end

  test "should not allow creation without amount" do
    params = @default_params.merge(amount: nil)
    price = Price.new(params)
    assert_not price.valid?
    assert_difference("Price.count", 0) do
      assert_not price.save
    end
  end

  test "should not allow negative amount" do
    params = @default_params.merge(amount: -10_000)
    price = Price.new(params)
    assert_not price.valid?
    assert_difference("Price.count", 0) do
      assert_not price.save
    end
  end

  test "should not allow creation with zero amount" do
    params = @default_params.merge(amount: 0)
    price = Price.new(params)
    assert_not price.valid?
    assert_difference("Price.count", 0) do
      assert_not price.save
    end
  end

  test "should not allow creation with float amount" do
    params = @default_params.merge(amount: 123.45)
    price = Price.new(params)
    assert_not price.valid?
    assert_difference("Price.count", 0) do
      assert_not price.save
    end
  end


  test "should not allow creation without date" do
    params = @default_params.merge(date: nil)
    price = Price.new(params)
    assert_not price.valid?
    assert_difference("Price.count", 0) do
      assert_not price.save
    end
  end
end
