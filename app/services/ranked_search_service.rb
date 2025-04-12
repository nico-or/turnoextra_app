class RankedSearchService < ApplicationService
  attr_reader :listing, :client

  def initialize(listing, client)
    @listing = listing
    @client = client
  end

  def call
    search_results = client.search(normalized_query)
    rank_results(query, search_results).map(&:first)
  end

  private

  def normalize_string(string)
    string.unicode_normalize(:nfkd).downcase.gsub(/[^a-z0-9 ]/, "")
  end

  def query
    case listing
    when Listing then listing.title
    when String then listing
    else raise ArgumentError, "Expected Listing or String, but got a #{listing.class}"
    end
  end

  def normalized_query
    normalize_string(query)
  end

  def rank_results(query, results)
    FuzzyMatch.new(results, read: :name)
              .find_all_with_score(query)
              .sort_by do |(result, dice_score, leve_score)|
                [ -dice_score, -leve_score, -result.year.to_i ]
              end
  end
end
