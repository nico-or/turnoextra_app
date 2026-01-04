require "test_helper"

class Impressions::ImpressionPolicyTest < ActiveSupport::TestCase
  REAL_USER_AGENTS = [
    "Mozilla/5.0 (Android 14; Mobile; rv:146.0) Gecko/146.0 Firefox/146.0",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5.1 Mobile/15E148 Safari/605.1.15 (Ecosia ios@11.5.2.2615)",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.1 Mobile/15E148 Safari/604.1",
    "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 OPR/124.0.0.0",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US) AppleWebKit/534.3 (KHTML, like Gecko) Chrome/6.0.472.33 Safari/534.3",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.122 Safari/537.36",
    "Mozilla/5.0 zgrab/0.x"
  ]

  BOT_USER_AGENTS = [
    # Note: both of these cases are handled by nginx
    # "-", "libredtail-http",
    "Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)",
    "Mozilla/5.0 (compatible; DotBot/1.2; +https://opensiteexplorer.org/dotbot; help@moz.com)",
    "Mozilla/5.0 (compatible; SemrushBot/7~bl; +http://www.semrush.com/bot.html)",
    "Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)",
    # This one is from a scrapper, but it's not detected as a bot user agent.
    # "Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.1 Mobile/15E148 Safari/604.1",
    "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.7390.122 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36; compatible; OAI-SearchBot/1.3; robots.txt; +https://openai.com/searchbot",
    "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Amazonbot/0.1; +https://developer.amazon.com/support/amazonbot) Chrome/119.0.6045.214 Safari/537.36",
    "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm) Chrome/116.0.1938.76 Safari/537.36"
  ]

  test "visitor is worthy" do
    user = nil
    REAL_USER_AGENTS.each do |user_agent|
      visitor = Visitor.new(user:, user_agent:)
      policy = Impressions::ImpressionPolicy.new(visitor)
      assert policy.eligible?
    end
  end

  test "regular user is worthy" do
    user = users(:user)
    REAL_USER_AGENTS.each do |user_agent|
      visitor = Visitor.new(user:, user_agent:)
      policy = Impressions::ImpressionPolicy.new(visitor)
      assert policy.eligible?
    end
  end

  test "admin is not worthy" do
    user = users(:admin)
    REAL_USER_AGENTS.each do |user_agent|
      visitor = Visitor.new(user:, user_agent:)
      policy = Impressions::ImpressionPolicy.new(visitor)
      assert_not policy.eligible?
    end
  end

  test "bot is not worthy" do
    user = nil
    BOT_USER_AGENTS.each do |user_agent|
      visitor = Visitor.new(user:, user_agent:)
      policy = Impressions::ImpressionPolicy.new(visitor)
      assert_not policy.eligible?
    end
  end

  test "known ip ranges are not worthy" do
    user = nil
    user_agent = "Test UA"
    remote_ips = [ "74.125.151.33" ]

    remote_ips.each do |ip_address|
      visitor = Visitor.new(user:, user_agent:, ip_address:)
      policy = Impressions::ImpressionPolicy.new(visitor)
      assert_not policy.eligible?, "failed for: #{ip_address}"
    end
  end
end
