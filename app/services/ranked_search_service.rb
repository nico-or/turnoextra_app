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
    return results unless results.empty?

    results = rank_query_with(SearchMethod::BggApiSearch.new(query), fallback_threshold)
    results
  end

  def rank_query_with(search_method, threshold)
    log_search_source(search_method.class.name.demodulize, threshold)
    search_results = search_method.call
    rank_results(search_results, threshold: threshold)
  end

  def rank_results(results, threshold:)
    SearchResultsRankerService.new(query, results, threshold: threshold).call
  end

  def normalized_query
    Text::Normalization.normalize_string(query)
  end

  def cache_key
    "ranked_search/#{normalized_query}"
  end

  def log_search_source(source, threshold)
    Rails.logger.info "Searching #{source} with threshold #{threshold}..."
  end
end
