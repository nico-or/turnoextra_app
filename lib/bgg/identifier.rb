module Bgg
  class Identifier
    # @param api_client [#search] returns a Array<Bgg::SearchResult>
    #   to be sorted/ranked
    def initialize(api_client = Api.new)
      @api = api_client
      @cache = {}
    end

    # Returns a list of sorted Bgg::SearchResult
    # @param query [Strig] the string to look for in BGG Api
    # @return [Array<Bgg::SearchResult>] sorted array of search results
    def identify!(query)
      norm_query = normalize_string(query)
      results = fetch_results(norm_query)
      rank_results(query, results).map(&:first)
    end

    private

    attr_reader :api, :cache

    def normalize_string(string)
      Unicode.decompose(string.downcase).gsub(/[^a-z0-9 ]/, "")
    end

    def fetch_results(query)
      return cache[query] if cache.key?(query)

      cache[query] = api.search(query)
    end

    def rank_results(query, results)
      # TODO: add :threshold argument
      # TODO: add BGG rank to the sort array
      FuzzyMatch.new(results, read: :name)
                .find_all_with_score(query)
                .sort_by do |(result, dice_score, leve_score)|
                  [ -dice_score, -leve_score, -result.year.to_i ]
                end
    end
  end
end
