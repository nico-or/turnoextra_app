require "test_helper"

class BggRankUpdateServiceTest < ActiveSupport::TestCase
  def setup
    @file_1 = file_fixture("bgg/ranks/bgg_ranks_top_5.csv")
    @file_2 = file_fixture("bgg/ranks/bgg_ranks_top_10.csv")
  end

  test "top_5 creates the 5 Boardgames" do
    assert_difference("Boardgame.count", 5) do
      BggRankUpdateService.new(@file_1).call
    end
  end

  test "top_10 creates the 10 Boardgames" do
    assert_difference("Boardgame.count", 10) do
      BggRankUpdateService.new(@file_2).call
    end
  end

  test "top_5 then top_10 creates only 10 Boardgames" do
    assert_difference("Boardgame.count", 10) do
      BggRankUpdateService.new(@file_1).call
      BggRankUpdateService.new(@file_2).call
    end
  end

  test "top_10 then top_5 creates only 10 Boardgames" do
    assert_difference("Boardgame.count", 10) do
      BggRankUpdateService.new(@file_2).call
      BggRankUpdateService.new(@file_1).call
    end
  end

  test "boardgames end up with the last rank imported" do
    BggRankUpdateService.new(@file_1).call
    assert_equal 1, Boardgame.find_by(bgg_id: 224517).rank

    BggRankUpdateService.new(@file_2).call
    assert_equal 2, Boardgame.find_by(bgg_id: 224517).rank

    BggRankUpdateService.new(@file_1).call
    assert_equal 1, Boardgame.find_by(bgg_id: 224517).rank
  end
end
