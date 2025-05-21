class BoardgameDealsService < ApplicationService
  attr_reader :reference_date, :reference_start_date

  def initialize(date = Price.latest_update_date)
    @reference_date = date
    @reference_start_date = reference_date - DailyBoardgameDeal::REFERENCE_WINDOW_SIZE
  end

  def call
    best_prices_cte = Price.joins(:listing)
      .where(date: reference_date)
      .select(
        "listings.boardgame_id AS boardgame_id",
        "prices.date AS date",
        "MIN(prices.amount) AS best_price"
      )
      .group("listings.boardgame_id", "prices.date")

    reference_medians_cte = Price.joins(:listing)
      .where(date: reference_start_date..reference_date)
      .select(
        "listings.boardgame_id AS boardgame_id",
        "CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY prices.amount) AS integer) AS reference_price"
      )
      .group("listings.boardgame_id")

    Boardgame.with(
        best_prices: best_prices_cte,
        reference_medians: reference_medians_cte
      )
      .select(
        "boardgames.id",
        "best_prices.date",
        "best_prices.best_price",
        "reference_medians.reference_price",
        "CAST(((1 - 1.0 * best_prices.best_price / reference_medians.reference_price) * 100) AS integer) AS discount"
      )
      .joins("JOIN best_prices ON best_prices.boardgame_id = boardgames.id")
      .joins("JOIN reference_medians ON reference_medians.boardgame_id = boardgames.id")
  end
end
