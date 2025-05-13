class RankedSearchService < ApplicationService
  attr_reader :query, :primary_threshold, :fallback_threshold

  def initialize(query, primary_threshold: 0.8, fallback_threshold: 0.5)
    @query = query
    @primary_threshold = primary_threshold
    @fallback_threshold = fallback_threshold
  end

  def call
    Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      Rails.logger.info "RankedSearchService called with query: #{query}"
      perform_ranked_search
    end
  end

  private

  def perform_ranked_search
    results = rank_query_with(SearchMethod::DatabaseSearch.new(query), primary_threshold)
    return extract_results(results) unless results.empty?

    results = rank_query_with(SearchMethod::BggApiSearch.new(query), fallback_threshold)
    extract_results(results)
  end

  def rank_query_with(search_method, threshold)
    log_search_source(search_method.class.name.demodulize, threshold)
    search_results = search_method.call
    rank_results(search_results, threshold: threshold)
  end

  def extract_results(ranked_results)
    ranked_results.map(&:first)
  end

  def rank_results(results, threshold:)
    FuzzyMatch.new(results, read: :title)
              .find_all_with_score(query, threshold: threshold)
              .sort_by { |result| ranking_criteria(*result) }
  end

  def ranking_criteria(result, dices_score, levenshtein_score)
    # TODO: use BGG Rank if available (must decide on how to handle unranked (rank=0) games)
    [
      -dices_score,
      -levenshtein_score,
      -result.year.to_i
    ]
  end

  def normalized_query
    StringNormalizationService.normalize_string(query)
  end

  def cache_key
    "ranked_search/#{normalized_query}"
  end

  def log_search_source(source, threshold)
    Rails.logger.info "Searching #{source} with threshold #{threshold}..."
  end
end
