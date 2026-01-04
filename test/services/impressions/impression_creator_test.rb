require "test_helper"

class Impressions::ImpressionCreatorTest < ActiveSupport::TestCase
  setup do
    @boardgame = Boardgame.first
    @impression = @boardgame.impressions.create!(date: Date.current, count: 0)
  end

  test "visitors do create impressions" do
    visitor = anonymous_visitor
    impression_creator = Impressions::ImpressionCreator.new(@boardgame, visitor:)

    assert_difference -> { @impression.reload.count }, 1 do
      impression_creator.create
    end
  end

  test "regular user do create impressions" do
    visitor = user_visitor
    impression_creator = Impressions::ImpressionCreator.new(@boardgame, visitor:)

    assert_difference -> { @impression.reload.count }, 1 do
      impression_creator.create
    end
  end

  test "admin do not create impressions" do
    visitor = admin_visitor
    impression_creator = Impressions::ImpressionCreator.new(@boardgame, visitor:)

    assert_no_difference -> { @impression.reload.count } do
      impression_creator.create
    end
  end

  test "bot do not create impressions" do
    visitor = bot_visitor
    impression_creator = Impressions::ImpressionCreator.new(@boardgame, visitor:)

    assert_no_difference -> { @impression.reload.count } do
      impression_creator.create
    end
  end

  test "known ip ranges do not create impressions" do
    ip_address = "74.125.151.33"
    visitor = anonymous_visitor(ip_address:)
    impression_creator = Impressions::ImpressionCreator.new(@boardgame, visitor:)

    assert_no_difference -> { @impression.reload.count } do
      impression_creator.create
    end
  end
end
