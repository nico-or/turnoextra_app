require "test_helper"

module Impressions
  class IpBlacklistTest < ActiveSupport::TestCase
    test "#includes? non-blacklisted ip" do
      ip = "127.0.0.1"
      assert_not IpBlacklist.include?(ip)
    end

    test "#includes? blacklisted ip" do
      ip = "74.125.151.42"
      assert IpBlacklist.include?(ip)
    end
  end
end
