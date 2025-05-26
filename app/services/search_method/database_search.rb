module SearchMethod
  class DatabaseSearch
    attr_reader :query

    def initialize(query)
      @query = query
    end

    def call
      Rails.cache.fetch(cache_key, expires_in: 1.hours) do
        (local_boardgames + local_listings).map do |bg|
          Bgg::SearchResult.new(bgg_id: bg.bgg_id, year: bg.year, title: bg.title)
        end
      end
    end

    private

    def cache_key
      "database_search/#{normalized_query}"
    end

    def normalized_query
      Text::Normalization.normalize_string(query)
    end

    def local_boardgames
      Boardgame.where("LOWER(boardgames.title)  = LOWER(?)", query)
        .where("rank > 0")
        .select("bgg_id", "title", "year")
        .distinct
    end

    def local_listings
      Boardgame.joins(:listings)
        .where("LOWER(listings.title)  = LOWER(?)", query)
        .where("rank > 0")
        .select("boardgames.bgg_id", "boardgames.year", "listings.title")
        .distinct
    end
  end
end
