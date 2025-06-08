require "test_helper"

class ImpressionTest < ActiveSupport::TestCase
  setup do
    @boardgame = Boardgame.create!(
      title: "Test Game",
      year: 2023,
      rank: 1,
      bgg_id: 123,
      image_url: "http://example.com/image.jpg",
      thumbnail_url: "http://example.com/thumbnail.jpg",
    )
  end

  test "should not be valid without trackable" do
    impression = Impression.new(trackable: nil, date: Date.current, count: 0)
    assert_not impression.valid?
  end

  test "should default date to current date" do
    impression = Impression.new(trackable: @boardgame)
    impression.save!
    assert_equal impression.date, Date.current
  end

  test "should create impression with provided date" do
    impression = Impression.new(trackable: @boardgame, date: Date.yesterday)
    impression.save!
    assert_equal impression.date, Date.yesterday
  end

  test "should default count to 0" do
    impression = Impression.new(trackable: @boardgame)
    impression.save!
    assert_equal impression.count, 0
  end

  test "should create impression" do
    impression = Impression.find_or_create_by!(trackable: @boardgame)

    assert_equal impression.trackable_type, "Boardgame"
    assert_equal impression.trackable_id, @boardgame.id
    assert_equal impression.date, Date.current
    assert_equal impression.count, 0
  end

  test "should not create duplicate impressions" do
    assert_difference("Impression.count", 1) do
      2.times do
        Impression.create(trackable: @boardgame, date: Date.current)
      end
    end
  end

  test "should create impression with different dates for the same trackable" do
    assert_difference("Impression.count", 2) do
      # Date.current and Date.current aren't the same!
      # Date.current ensures compatible values with Date.yesterday
      Impression.create(trackable: @boardgame, date: Date.yesterday)
      Impression.create(trackable: @boardgame, date: Date.current)
    end
  end
end
