module Boardgames
  # Provides the data required to build
  # the Listings table on the boardgames#show view
  class AvailableListings
    def initialize(boardgame)
      @boardgame = boardgame
    end

    def data
      listings_data
    end

    private

    attr_reader :boardgame

    def reference_date
      Price.latest_update_date
    end

    def listings_data
      Listing
        .joins(:prices, :store)
        .where(boardgame: boardgame)
        .where(prices: { date: reference_date })
        .group("listings.id", "stores.id")
        .order("best_price ASC")
        .select(
          "listings.id",
          "listings.url",
          "listings.title",
          "stores.id AS store_id",
          "stores.name AS store_name",
          "MIN(prices.amount) AS best_price",
        )
    end
  end
end
