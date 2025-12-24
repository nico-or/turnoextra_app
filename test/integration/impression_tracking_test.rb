require "test_helper"

class ImpressionTrackingTest < ActionDispatch::IntegrationTest
  setup do
    @visits = 2
    @old_count = 1
    @boardgame = boardgames(:catan)
    @impression = @boardgame.impressions.create!(date: Date.current, count: @old_count)
  end

  test "logged in admin does not trigger impressions" do
    login_admin
    @visits.times do
      assert_no_difference -> { @impression.reload.count } do
        get boardgame_path(@boardgame)
      end
    end
  end

  test "anonymous visitor triggers impressions" do
    assert_difference -> { @impression.reload.count }, @visits do
      @visits.times do
        get boardgame_path(@boardgame)
      end
    end
  end
end
