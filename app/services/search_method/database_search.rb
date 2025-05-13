module SearchMethod
  class DatabaseSearch
    attr_reader :query

    def initialize(query)
      @query = query
    end

    def call
      Rails.cache.fetch("database_search/#{truncated_query}", expires_in: 1.hours) do
        (local_boardgames + local_listings).map do |bg|
          Bgg::SearchResult.new(bgg_id: bg.bgg_id, year: bg.year, title: bg.title)
        end
      end
    end

    private

    def normalized_query
      StringNormalizationService.normalize_string(query)
    end

    def truncated_query
      normalized_query.truncate_words(2, omission: "")
    end

    def local_boardgames
      Boardgame.where("LOWER(boardgames.title) LIKE LOWER(?)", "%#{truncated_query}%")
              .select("bgg_id", "title", "year")
              .distinct
    end

    def local_listings
      Boardgame.joins(:listings)
              .where("LOWER(listings.title) LIKE LOWER(?)", "%#{truncated_query}%")
              .select("boardgames.bgg_id", "boardgames.year", "listings.title")
              .distinct
    end
  end
end
