class BoardgamesController < ApplicationController
  skip_before_action :authorize_user, only: %i[index show]
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

    prices_today = Price.where(date: @reference_date)
    @listings = Listing
      .with(prices_today: prices_today)
      .joins(:store)
      .joins("INNER JOIN prices_today ON prices_today.listing_id = listings.id")
      .where(boardgame: @boardgame)
      .group("listings.id")
      .order("best_price ASC")
      .select(
        "listings.url",
        "listings.title",
        "stores.name AS store_name",
        "MIN(prices_today.amount) AS best_price"
      )

      reference_price = @boardgame.reference_price.to_f
      if reference_price.zero?
        @discount = 0
      else
        best_price = @listings.map { _1.best_price }.min
        @discount = ((1 - best_price / reference_price) * 100).to_i
      end

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
      "stores.name AS store_name",
      "prices.amount AS amount",
      "prices.date AS date"
      )

    price_data.group_by(&:store_name).map do |store_name, records|
      {
        name: store_name,
        data: date_range.map do |date|
          [ date, records.find { it.date == date }&.amount ]
        end
      }
    end
  end
end
