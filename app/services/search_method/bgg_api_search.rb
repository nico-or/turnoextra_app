module SearchMethod
  class BggApiSearch < ApplicationService
    attr_reader :query, :client

    def initialize(query)
      @query = query
      @client = Bgg::Client.new
    end

    def call
      api_results = client.search(normalized_query)

      bgg_ids = api_results.map(&:bgg_id)

      indexed_ranks = Boardgame.where(bgg_id: bgg_ids).pluck(:bgg_id, :rank).to_h

      api_results.map { |result| build_result(result, indexed_ranks) }
    end

    private

    def normalized_query
      Text::Normalization.normalize_title(query)
    end

    def build_result(result, indexed_ranks)
      SearchResult.new(
        bgg_id: result.bgg_id,
        title: result.title,
        year: result.year,
        similarity: Text::Trigram.similarity(@query, result.title),
        rank: indexed_ranks[result.bgg_id] || 0
      )
    end
  end
end
