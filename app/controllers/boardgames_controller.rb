class BoardgamesController < ApplicationController
  def index
    latest_date = Price.maximum(:date)

    @boardgames = Boardgame
    .joins(listings: [ :prices ])
    .where(prices: { date: latest_date })
    .order(:title)
    .group("boardgames.id")
    .select("boardgames.*",
    "MIN(prices.amount) AS price")
    .distinct

    if params[:q].present?
      @boardgames = @boardgames.with_title_like(params[:q])
    end

    @pagy, @boardgames = pagy(@boardgames, limit: 12)
  end

  def show
    @boardgame = Boardgame.find(params[:id])
    @reference_date = Price.latest_update_date

    @listings = Listing.joins(:prices, :store)
      .where(boardgame: @boardgame)
      .where(prices: { date: @reference_date })
      .group("listings.id", "stores.id")
      .order("best_price ASC")
      .select(
        "listings.id",
        "listings.url",
        "listings.title",
        "stores.id AS store_id",
        "stores.name AS store_name",
        "MIN(prices.amount) AS best_price")

      @chart_data = chart_data
  end

  private

  def date_range
    (@reference_date - 2.weeks)..@reference_date
  end

  def chart_data
    price_data = @boardgame.prices
      .joins(listing: [ :store ])
      .where(date: date_range)
      .select(
      "listings.id AS listing_id",
      "stores.name AS store_name",
      "prices.amount AS amount",
      "prices.date AS date"
      )

    price_data.group_by(&:listing_id).map do |listing_id, records|
      {
        name: records.first.store_name,
        data: date_range.map do |date|
          [ date, records.find { it.date == date }&.amount ]
        end
      }
    end
  end
end
