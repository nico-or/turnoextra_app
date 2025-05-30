require "test_helper"

class ImpressionCountTest < ActionDispatch::IntegrationTest
  setup do
    @boardgame = boardgames(:catan)
  end

  test "should increment impression count" do
    get boardgame_path(@boardgame)
    impression = Impression.last
    assert_not_nil impression
    assert_equal Date.today, impression.date
    assert_equal 1, impression.count
  end

  test "should increment existing impression count when visiting again" do
    get boardgame_path(@boardgame)
    first_impression = Impression.last
    assert_not_nil first_impression
    assert_equal Date.today, first_impression.date
    assert_equal 1, first_impression.count

    # Visit again
    assert_no_difference "Impression.count" do
      get boardgame_path(@boardgame)
    end

    second_impression = Impression.last
    assert_not_nil second_impression
    assert_equal Date.today, second_impression.date
    assert_equal 2, second_impression.count
  end
end
