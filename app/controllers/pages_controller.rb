class PagesController < ApplicationController
  def home
    reference_date = Price.latest_update_date

    @deals = Boardgame.joins(:daily_boardgame_deals)
      .select(
        "boardgames.id",
        "boardgames.title",
        "boardgames.thumbnail_url",
        "daily_boardgame_deals.discount",
        "daily_boardgame_deals.best_price",
        "daily_boardgame_deals.reference_price")
      .where(daily_boardgame_deals: { date: reference_date })
      .where("daily_boardgame_deals.discount > 0")
      .order("discount DESC")
      .distinct
      .limit(8)
  end
end
