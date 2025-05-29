module SearchMethod
  class SearchResultRanker
    RANK_WEIGHT = 0.4
    SIMILARITY_WEIGHT = 0.6

    attr_reader :results

    def initialize(results, max_rank: nil)
      @results = results
      @max_rank = max_rank
    end

    def call
      results.sort_by { |result| -1*result_score(result) }
    end

    private

    def result_score(result)
      [
        rank_score(result.rank),
        similarity_score(result.similarity)
      ].sum
    end

    def max_rank
      @max_rank ||= Boardgame.maximum(:rank)
    end

    # lower ranks are better, except for zero, which means no rank at all.
    def rank_score(rank)
      return 0 if rank.zero?

      score =  1 - (rank.to_f / max_rank)
      RANK_WEIGHT * score
    end

    # higher similarity is better.
    def similarity_score(similarity)
      SIMILARITY_WEIGHT * similarity
    end
  end
end
