require "test_helper"

class Impressions::ImpressionPolicyTest < ActiveSupport::TestCase
  test "visitor is worthy" do
    visitor = anonymous_visitor
    policy = Impressions::ImpressionPolicy.new(visitor)
    assert policy.eligible?
  end

  test "regular user is worthy" do
    visitor = user_visitor
    policy = Impressions::ImpressionPolicy.new(visitor)
    assert policy.eligible?
  end

  test "admin is not worthy" do
    visitor = admin_visitor
    policy = Impressions::ImpressionPolicy.new(visitor)
    assert_not policy.eligible?
  end

  test "bot is not worthy" do
    visitor = bot_visitor
    policy = Impressions::ImpressionPolicy.new(visitor)
    assert_not policy.eligible?
  end

  test "known ip ranges are not worthy" do
    ip_address = "74.125.151.33"
    visitor = anonymous_visitor(ip_address:)
    policy = Impressions::ImpressionPolicy.new(visitor)
    assert_not policy.eligible?
  end
end
