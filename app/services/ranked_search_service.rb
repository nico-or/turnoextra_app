class RankedSearchService < ApplicationService
  attr_reader :query

  def initialize(query)
    @query = query
  end

  def call
    Rails.cache.fetch("ranked_search/#{normalized_query}", expires_in: 1.hours) do
      search
    end
  end

  private

  def normalized_query
    StringNormalizationService.normalize_string(query)
  end

  def search
    Rails.logger.info "RankedSearchService called with query: #{query}"

    threshold = 0.8
    Rails.logger.info "Searching Database with threshold #{threshold}..."
    search_results = SearchMethod::DatabaseSearch.new(query).call
    ranked_results = rank_results(query, search_results, threshold: threshold)

    if ranked_results.empty?
      threshold = 0.5
      Rails.logger.info "Searching BGG API with threshold #{threshold}..."
      search_results = SearchMethod::BggApiSearch.new(query).call
      ranked_results = rank_results(query, search_results, threshold: threshold)
    end

    ranked_results.map(&:first)
  end

  def rank_results(query, results, threshold: 0)
    FuzzyMatch.new(results, read: :name)
              .find_all_with_score(query, threshold: threshold)
              .sort_by do |(result, dice_score, leve_score)|
                # TODO: sort with boardgamegeek rank (problem if unranked ie. rank = 0)
                # TODO: decide on whether rank or year should be prioritized, or a weighted average
                [ -dice_score, -leve_score, -result.year.to_i ]
              end
  end
end
