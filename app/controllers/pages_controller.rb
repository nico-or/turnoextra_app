class PagesController < ApplicationController
  def home
    reference_date = Price.latest_update_date
    yesterday_date = reference_date - 1.day

    yesterday_prices = Boardgame.joins(:prices)
    .where(prices: { date: yesterday_date })
    .select(
      "boardgames.id AS boardgame_id",
      "MIN(prices.amount) AS amount"
    )
    .group("boardgames.id")

    base_query = Boardgame.joins(:daily_boardgame_deals)
      .select(
        "boardgames.id",
        "boardgames.title",
        "boardgames.thumbnail_url",
        "daily_boardgame_deals.discount",
        "daily_boardgame_deals.best_price",
        "daily_boardgame_deals.reference_price")
      .limit(8)

    @deals = base_query
      .where("daily_boardgame_deals.discount > 0")
      .order("discount DESC")

    @new_deals = base_query
      .with(yesterday_prices: yesterday_prices)
      .joins("JOIN yesterday_prices ON yesterday_prices.boardgame_id = boardgames.id")
      .where("yesterday_prices.amount > daily_boardgame_deals.best_price")
      .order("discount DESC")

    @top_bgg = base_query
      .where("boardgames.rank > 0")
      .order("boardgames.rank ASC")

    date_window = (reference_date - 7.days..reference_date)
    @most_viewed = base_query
      .joins(:impressions)
      .where(impressions: { date: date_window })
      .group(
        "boardgames.id",
        "boardgames.title",
        "boardgames.thumbnail_url",
        "daily_boardgame_deals.discount",
        "daily_boardgame_deals.best_price",
        "daily_boardgame_deals.reference_price"
      )
      .select("SUM(impressions.count) AS view_count")
      .order("view_count DESC")
  end
end
