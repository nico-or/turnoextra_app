require "test_helper"

module SearchMethod
  class SearchResultRankerTest < ActiveSupport::TestCase
    def setup
      @max_rank = 1000
    end

    def result(bgg_id:, similarity:, rank:)
      SearchResult.new(
        bgg_id: bgg_id,
        title: "Game #{bgg_id}",
        year: 2020,
        similarity: similarity,
        rank: rank
      )
    end

    test "sorts by combined similarity and rank score" do
      results = [
        result(bgg_id: 1, similarity: 0.8, rank: 500),
        result(bgg_id: 2, similarity: 0.5, rank: 100),
        result(bgg_id: 3, similarity: 0.9, rank: 0)
      ]

      ranked = SearchResultRanker.new(results, max_rank: @max_rank).call
      assert_equal [ 1, 2, 3 ], ranked.map(&:bgg_id)
    end

    test "penalizes rank 0 (no rank)" do
      results = [
        result(bgg_id: 1, similarity: 0.8, rank: 0),
        result(bgg_id: 2, similarity: 0.8, rank: 100)
      ]
      ranked = SearchResultRanker.new(results, max_rank: @max_rank).call

      assert_equal 2, ranked.first.bgg_id
    end

    test "resolves ties with similarity as tie-breaker" do
      results = [
        result(bgg_id: 1, similarity: 0.6, rank: 100),
        result(bgg_id: 2, similarity: 0.9, rank: 100)
      ]
      ranked = SearchResultRanker.new(results, max_rank: @max_rank).call

      assert_equal 2, ranked.first.bgg_id
    end

    test "handles all zero scores" do
      results = [
        result(bgg_id: 1, similarity: 0.0, rank: 0),
        result(bgg_id: 2, similarity: 0.0, rank: 0)
      ]
      ranked = SearchResultRanker.new(results, max_rank: @max_rank).call

      assert_equal [ 1, 2 ], ranked.map(&:bgg_id)
    end
  end
end
