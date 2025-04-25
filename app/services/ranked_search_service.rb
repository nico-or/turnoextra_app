class RankedSearchService < ApplicationService
  attr_reader :listing, :client

  def initialize(listing, client)
    @listing = listing
    @client = client
  end

  def call
    search_results = client.search(normalized_query)
    search_results = client.search(truncated_query) if search_results.empty?

    rank_results(query, search_results).map(&:first)
  end

  private

  def query
    case listing
    when Listing then listing.title
    when String then listing
    else raise ArgumentError, "Expected Listing or String, but got a #{listing.class}"
    end
  end

  def normalized_query
    StringNormalizationService.normalize_title(query)
  end

  def truncated_query(word_count = 3)
    normalized_query.truncate_words(word_count, omission: "")
  end

  def rank_results(query, results)
    FuzzyMatch.new(results, read: :name)
              .find_all_with_score(query)
              .sort_by do |(result, dice_score, leve_score)|
                [ -dice_score, -leve_score, -result.year.to_i ]
              end
  end
end
