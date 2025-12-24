require "test_helper"

class ImpressionTrackingTest < ActionDispatch::IntegrationTest
  REAL_USER_AGENT = "Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0"
  BOT_USER_AGENT = "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"

  def get_boardgame(boardgame, user_agent)
    get boardgame_path(@boardgame), headers: { "User-agent" => user_agent }
  end

  setup do
    @visits = 2
    @old_count = 1
    @boardgame = boardgames(:catan)
    @impression = @boardgame.impressions.create!(date: Date.current, count: @old_count)
  end

  test "logged in admin does not trigger impressions" do
    user_agent = REAL_USER_AGENT
    login_admin
    @visits.times do
      assert_no_difference -> { @impression.reload.count } do
        get_boardgame(@boardgame, user_agent)
      end
    end
  end

  test "anonymous visitor triggers impressions" do
    user_agent = REAL_USER_AGENT
    assert_difference -> { @impression.reload.count }, @visits do
      @visits.times do
        get_boardgame(@boardgame, user_agent)
      end
    end
  end

  test "bot does not triggers impressions" do
    user_agent = BOT_USER_AGENT
    assert_no_difference -> { @impression.reload.count } do
      @visits.times do
        get_boardgame(@boardgame, user_agent)
      end
    end
  end
end
