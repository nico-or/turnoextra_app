class SearchResultsRankerService
  attr_reader :query, :results, :threshold, :ranks_data, :max_rank_value

  def initialize(query, results, threshold: 0.8, ranks: nil, max_rank: nil)
    @query = query
    @results = results
    @threshold = threshold
    @ranks_data = ranks
    @max_rank_value = max_rank
  end

  def call
    ranked_results = rank_results(results, threshold: threshold)
    extract_results(ranked_results)
  end

  private

  def extract_results(ranked_results)
    ranked_results.map(&:first)
  end

  def ranks
    @ranks ||= ranks_data || Boardgame.where(bgg_id: results.map(&:bgg_id))
                                      .select(:id, :bgg_id, :rank)
                                      .index_by(&:bgg_id)
  end

  def rank_results(results, threshold:)
    results.map { |result| [ result, Text::Trigram.similarity(query, result.title) ] }
           .sort_by { |(result, similarity)| -ranking_score(result, similarity) }
  end

  def ranking_score(result, similarity)
    weight_similarity = 0.4
    weight_rank = 0.6
    weight_year = 0

    score_similarity = weight_similarity * similarity # scores go from 0 to 1 (higher is better)
    score_rank = weight_rank * bgg_rank_score(result)
    score_year = weight_year * year_score(result.year)

    [ score_similarity, score_rank, score_year ].sum
  end

  # score goes from 0 to 1 (higher is better)
  def bgg_rank_score(result)
    rank = ranks[result.bgg_id]&.rank.to_i
    return 0 if rank.zero?
    1 - (rank.to_f - 1)/max_rank
  end

  # score goes from 0 to 1 (higher is better)
  def year_score(year)
    year.to_f / Date.today.year
  end

  def max_rank
    @max_rank ||= max_rank_value || Boardgame.maximum(:rank)
  end
end
