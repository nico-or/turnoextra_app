require "test_helper"

class DailyBoardgameDealTest < ActiveSupport::TestCase
  def setup
    @boardgame = boardgames(:pandemic) # assumes you have a fixture for a boardgame
    @valid_attributes = {
      boardgame_id: @boardgame.id,
      best_price: 3000,
      reference_price: 5000,
      discount: 2000
    }
  end

  test "should create a new daily boardgame deal with valid attributes" do
    deal = DailyBoardgameDeal.new(@valid_attributes)
    assert_difference("DailyBoardgameDeal.count", 1) do
      assert deal.save
    end
  end

  test "should not allow creation without boardgame_id" do
    attrs = @valid_attributes.merge(boardgame_id: nil)
    deal = DailyBoardgameDeal.new(attrs)
    assert_not deal.valid?
  end

  test "should not allow creation without best_price" do
    attrs = @valid_attributes.merge(best_price: nil)
    deal = DailyBoardgameDeal.new(attrs)
    assert_not deal.valid?
  end

  test "should not allow negative best_price" do
    attrs = @valid_attributes.merge(best_price: -100)
    deal = DailyBoardgameDeal.new(attrs)
    assert_not deal.valid?
  end

  test "should not allow float best_price" do
    attrs = @valid_attributes.merge(best_price: 123.45)
    deal = DailyBoardgameDeal.new(attrs)
    assert_not deal.valid?
  end

  test "should not allow creation without reference_price" do
    attrs = @valid_attributes.merge(reference_price: nil)
    deal = DailyBoardgameDeal.new(attrs)
    assert_not deal.valid?
  end

  test "should not allow negative reference_price" do
    attrs = @valid_attributes.merge(reference_price: -10)
    deal = DailyBoardgameDeal.new(attrs)
    assert_not deal.valid?
  end

  test "should not allow float reference_price" do
    attrs = @valid_attributes.merge(reference_price: 456.78)
    deal = DailyBoardgameDeal.new(attrs)
    assert_not deal.valid?
  end

  test "should not allow creation without discount" do
    attrs = @valid_attributes.merge(discount: nil)
    deal = DailyBoardgameDeal.new(attrs)
    assert_not deal.valid?
  end

  test "should not allow negative discount" do
    attrs = @valid_attributes.merge(discount: -500)
    deal = DailyBoardgameDeal.new(attrs)
    assert_not deal.valid?
  end

  test "should not allow float discount" do
    attrs = @valid_attributes.merge(discount: 99.99)
    deal = DailyBoardgameDeal.new(attrs)
    assert_not deal.valid?
  end
end
