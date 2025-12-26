module Boardgames
  # Provides the data required to build the Listing's
  # price history plot on the boardgames#show view.
  class PricePlotData
    DATE_WINDOW = 2.weeks

    def initialize(boardgame)
      @boardgame = boardgame
    end
    def data
      chart_data
    end

    private

    attr_reader :boardgame

    def reference_date
      Price.latest_update_date
    end

    def date_range
      (reference_date - DATE_WINDOW)..reference_date
    end

    def prices_data
      Listing
        .joins(:prices, :store)
        .where(boardgame: boardgame)
        .where(prices: { date: date_range })
        .select(
        "listings.id AS listing_id",
        "stores.name AS store_name",
        "prices.amount AS amount",
        "prices.date AS date",
        )
    end

    # Format data as required by Chartkick gem.
    # [
    #   { name: series_name, data: [ { x1 => y1 }, { x2 => y2 }, ... ] }, # format 1
    #   { name: series_name, data: [ [ x1, y1 ], [ x2, y2 ], ... ] },     # format 2
    #   ...
    # ]
    def chart_data
      prices_data.group_by(&:listing_id).map do |_listing_id, records|
        {
          name: records.first.store_name,
          data: date_range.map do |date|
            [ date, records.find { it.date == date }&.amount ]
          end
        }
      end
    end
  end
end
