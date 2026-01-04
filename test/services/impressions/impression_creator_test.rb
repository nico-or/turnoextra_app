require "test_helper"

class Impressions::ImpressionCreatorTest < ActiveSupport::TestCase
  REAL_UA = "REAL USER AGENT"
  BOT_UA = "BOT USER AGENT"

  setup do
    @boardgame = Boardgame.first
    @impression = @boardgame.impressions.create!(date: Date.current, count: 0)
  end

  test "visitors do create impressions" do
    user = nil
    user_agent = REAL_UA
    visitor = Visitor.new(user:, user_agent:)
    impression_creator = Impressions::ImpressionCreator.new(@boardgame, visitor:)

    assert_difference -> { @impression.reload.count }, 1 do
      impression_creator.create
    end
  end

  test "regular user do create impressions" do
    user = users(:user)
    user_agent = REAL_UA
    visitor = Visitor.new(user:, user_agent:)
    impression_creator = Impressions::ImpressionCreator.new(@boardgame, visitor:)

    assert_difference -> { @impression.reload.count }, 1 do
      impression_creator.create
    end
  end

  test "admin do not create impressions" do
    user = users(:admin)
    user_agent = REAL_UA
    visitor = Visitor.new(user:, user_agent:)
    impression_creator = Impressions::ImpressionCreator.new(@boardgame, visitor:)

    assert_no_difference -> { @impression.reload.count } do
      impression_creator.create
    end
  end

  test "bot do not create impressions" do
    user = nil
    user_agent = BOT_UA
    visitor = Visitor.new(user:, user_agent:)
    impression_creator = Impressions::ImpressionCreator.new(@boardgame, visitor:)

    assert_no_difference -> { @impression.reload.count } do
      impression_creator.create
    end
  end

  test "known ip ranges do not create impressions" do
    user = nil
    user_agent = REAL_UA
    remote_ips = [ "74.125.151.33" ]

    remote_ips.each do |ip_address|
      visitor = Visitor.new(user:, user_agent:, ip_address:)
      impression_creator = Impressions::ImpressionCreator.new(@boardgame, visitor:)

      assert_no_difference -> { @impression.reload.count } do
        impression_creator.create
      end
    end
  end
end
