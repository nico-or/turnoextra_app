require "test_helper"

class Bgg::RankUpdateServiceTest < ActiveSupport::TestCase
  def setup
    @file_1 = file_fixture("bgg/ranks/bgg_ranks_top_5.csv")
    @file_2 = file_fixture("bgg/ranks/bgg_ranks_top_10.csv")
  end

  test "top_5 creates the 5 Boardgames" do
    assert_difference("Boardgame.count", 5) do
      Bgg::RankUpdateService.new(@file_1).call
    end
  end

  test "top_10 creates the 10 Boardgames" do
    assert_difference("Boardgame.count", 10) do
      Bgg::RankUpdateService.new(@file_2).call
    end
  end

  test "top_5 then top_10 creates only 10 Boardgames" do
    assert_difference("Boardgame.count", 10) do
      Bgg::RankUpdateService.new(@file_1).call
      Bgg::RankUpdateService.new(@file_2).call
    end
  end

  test "top_10 then top_5 creates only 10 Boardgames" do
    assert_difference("Boardgame.count", 10) do
      Bgg::RankUpdateService.new(@file_2).call
      Bgg::RankUpdateService.new(@file_1).call
    end
  end

  test "boardgames end up with the last rank imported" do
    Bgg::RankUpdateService.new(@file_1).call
    assert_equal 1, Boardgame.find_by(bgg_id: 224517).rank

    Bgg::RankUpdateService.new(@file_2).call
    assert_equal 2, Boardgame.find_by(bgg_id: 224517).rank

    Bgg::RankUpdateService.new(@file_1).call
    assert_equal 1, Boardgame.find_by(bgg_id: 224517).rank
  end
end
