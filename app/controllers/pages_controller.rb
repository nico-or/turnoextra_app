class PagesController < ApplicationController
  def home
    reference_date = DailyBoardgameDeal.latest_update_date

    base_query = Boardgame.joins(:daily_boardgame_deals)
      .select(
        "boardgames.id",
        "boardgames.title",
        "boardgames.thumbnail_url",
        "daily_boardgame_deals.discount",
        "daily_boardgame_deals.best_price",
        "daily_boardgame_deals.reference_price")
      .where(daily_boardgame_deals: { date: reference_date })

    @deals = base_query
      .where("daily_boardgame_deals.discount > 0")
      .order("discount DESC")
      .limit(8)

    @top_bgg = base_query
      .where("boardgames.rank > 0")
      .order("boardgames.rank ASC")
      .limit(8)

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
      .limit(8)
  end
end
